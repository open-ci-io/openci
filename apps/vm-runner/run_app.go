package main

import (
	"context"
	"encoding/base64"
	"fmt"
	"log"
	"strings"
	"time"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go"
	"github.com/getsentry/sentry-go"
	"github.com/google/uuid"
	"github.com/urfave/cli/v3"
	"golang.org/x/crypto/ssh"
	"google.golang.org/api/option"
)

func RunApp(ctx context.Context, cmd *cli.Command) error {
	sentryDSN := cmd.String("s")
	keyPath := cmd.String("f")
	bucketName := cmd.String("b")

	infoLogger, errorLogger := InitializeLoggers()

	if err := InitializeSentry(sentryDSN); nil != err {
		log.Fatalf("Sentry initialization failed: %s", err)
	}
	defer sentry.Flush(2 * time.Second)

	config := &firebase.Config{
		StorageBucket: bucketName,
	}

	opt := option.WithCredentialsFile(keyPath)
	app, err := firebase.NewApp(context.Background(), config, opt)
	if nil != err {
		errorLogger.Printf("error initializing app: %v", err)
		return fmt.Errorf("error initializing app: %v", err)
	}

	firestoreClient, err := app.Firestore(ctx)
	if nil != err {
		sentry.CaptureMessage(fmt.Sprintf("error initializing Firestore: %v", err))
		return fmt.Errorf("error initializing Firestore: %v", err)
	}
	defer firestoreClient.Close()

	for {
		infoLogger.Printf("Starting Runner with key path: %s", keyPath)
		if err := handleVMProcess(ctx, infoLogger, errorLogger, firestoreClient, cmd, app); err != nil {
			errorLogger.Printf("Runner failed, but continuing: %v", err)
			sentry.CaptureException(err)
		}

		time.Sleep(10 * time.Second)
	}

}

func handleVMProcess(
	ctx context.Context,
	infoLogger,
	errorLogger *log.Logger,
	firestoreClient *firestore.Client,
	cmd *cli.Command,
	app *firebase.App,
) error {

	buildContext, err := prepareBuildContext(ctx, firestoreClient, cmd, infoLogger)
	if err != nil {
		return fmt.Errorf("failed to prepare build context: %v", err)
	}

	infoLogger.Printf("Build context prepared: %v", buildContext)

	vmName := uuid.New().String()

	defer func() {
		CleanupVMs(vmName, infoLogger)
	}()

	StartVM(vmName, infoLogger, errorLogger)

	client, sshErr := connectSSHOnVM(vmName, infoLogger)
	if nil != sshErr {
		sentry.CaptureMessage(fmt.Sprintf("Error connecting to VM via SSH: %v", sshErr))
		return fmt.Errorf("error connecting to VM via SSH: %v", sshErr)
	}
	defer client.Close()

	cmd2 := cloneCommand(buildContext.Job.GitHub.RepoURL, buildContext.Job.GitHub.BuildBranch, buildContext.GitHubInstallationToken)
	fmt.Printf("cmd2: %s", cmd2)
	sshOutput, err := ExecuteSSHCommand(client, cmd2, infoLogger)
	UploadLogToFirebaseStorage(ctx, app, buildContext.Job.ID, sshOutput)
	if err != nil {
		return fmt.Errorf("failed to clone repo: %v, sshOutput: %+v", err, sshOutput)
	}

	// cmdList := buildContext.Workflow.Steps

	// secretMap := convertSecretsToMap(buildContext.Secrets)

	/// TODO: ASCのAPIをたたき、cer-> p12 -> キーチェーンに追加 -> Xcodeを確認 -> flutter build ipa -> TestFlightにアップロード -> ビルド完了 ->
	///
	/// TODO: 上の流れをOpenCIに書き込み

	appStoreClient, err := InitAppStoreClient(cmd)
	if err != nil {
		return err
	}

	profiles, err := GetProvisioningProfiles(ctx, appStoreClient)
	if err != nil {
		return err
	}
	profile := profiles.Data[0]

	profileData, err := base64.StdEncoding.DecodeString(*profile.Attributes.ProfileContent)
	if err != nil {
		return fmt.Errorf("failed to decode profile content: %v", err)
	}
	// Base64エンコードされたデータをSSHコマンドで送信可能な形式に変換
	encodedProfile := base64.StdEncoding.EncodeToString(profileData)
	profilePath := fmt.Sprintf("/Users/admin/Library/MobileDevice/Provisioning Profiles/%s.mobileprovision", *profile.Attributes.UUID)

	// プロファイルを保存するためのSSHコマンドを作成
	mkdirCmd := "mkdir -p '/Users/admin/Library/MobileDevice/Provisioning Profiles/'"
	output, err := ExecuteSSHCommand(client, mkdirCmd, infoLogger)
	if err != nil {
		return fmt.Errorf("failed to create profiles directory: %v", err)
	}
	infoLogger.Printf("Successfully created profiles directory: %v", output)

	// Base64デコードしてファイルに保存するコマンド
	// -n オプションを削除し、入力を一時ファイルに保存してから処理
	saveCmd := fmt.Sprintf("echo '%s' | base64 -D > '%s'", encodedProfile, profilePath)
	output, err = ExecuteSSHCommand(client, saveCmd, infoLogger)
	if err != nil {
		infoLogger.Printf("Failed to save profile: %v", output)
		return fmt.Errorf("failed to save profile: %v", err)
	}
	infoLogger.Printf("Successfully saved profile: %v", output)

	err = GetCertificateContent(ctx, appStoreClient, client, infoLogger, cmd.String("app-store-key"))
	if err != nil {
		return err
	}

	time.Sleep(10 * time.Minute)

	// for _, cmd := range cmdList {
	// 	processedCmd := replaceEnvironmentVariables(cmd.Command, secretMap)
	// 	newCmd := fmt.Sprintf("source ~/.zshrc && cd %s && %s", buildContext.Workflow.CurrentWorkingDirectory, processedCmd)
	// 	infoLogger.Printf("Executing command: %s", newCmd)

	// 	res, err := ExecuteSSHCommand(client, newCmd, infoLogger)
	// 	UploadLogToFirebaseStorage(ctx, app, buildContext.Job.ID, res)

	// 	if err != nil {
	// 		if err := setBuildStatus(firestoreClient, buildContext.Job.ID, "failure", ctx); err != nil {
	// 			infoLogger.Printf("Failed to update build status: %v", err)
	// 		}
	// 		return fmt.Errorf("failed to execute command: %v, output: %+v", err, res)
	// 	}

	// 	infoLogger.Printf("Command executed successfully: %+v", res)
	// }

	// if err := setBuildStatus(firestoreClient, buildContext.Job.ID, "success", ctx); err != nil {
	// 	infoLogger.Printf("Failed to update build status: %v", err)
	// 	return fmt.Errorf("failed to update final build status: %v", err)
	// }

	return nil
}

func setBuildStatus(firestoreClient *firestore.Client, jobId string, status string, ctx context.Context) error {
	updates := []firestore.Update{
		{
			Path:  "buildStatus",
			Value: status,
		},
	}

	_, err := firestoreClient.Collection("build_jobs_v3").Doc(jobId).Update(ctx, updates)
	if err != nil {
		return fmt.Errorf("failed to update build status: %v", err)
	}

	return nil
}

func cloneCommand(repoURL, buildBranch, token string) string {
	fmt.Printf("repoURL: %s, buildBranch: %s, token: %s", repoURL, buildBranch, token)
	repoWithoutProtocol := strings.TrimPrefix(repoURL, "https://")
	return fmt.Sprintf("git clone -b %s https://x-access-token:%s@%s",
		buildBranch,
		token,
		repoWithoutProtocol,
	)
}

type BuildContext struct {
	Job                     *BuildJob
	GitHubInstallationToken string
	Workflow                *Workflow
	Secrets                 []Secret
}

func prepareBuildContext(ctx context.Context, client *firestore.Client, cmd *cli.Command, logger *log.Logger) (*BuildContext, error) {
	job, err := GetBuildJob(ctx, client, logger)
	if err != nil {
		return nil, fmt.Errorf("no build jobs found")
	}

	token, err := GetGitHubInstallationToken(cmd.String("p"), int64(job.GitHub.InstallationId), int64(job.GitHub.AppId), logger)
	if err != nil {
		sentry.CaptureMessage(fmt.Sprintf("Failed to get GitHub installation token: %v", err))
		return nil, fmt.Errorf("failed to get GitHub installation token: %v", err)
	}

	workflow, err := GetWorkflow(ctx, client, job.WorkflowId)
	if err != nil {
		return nil, fmt.Errorf("failed to get workflow: %v", err)
	}

	secrets, err := GetSecrets(workflow.Owners, client, ctx)
	if err != nil {
		return nil, fmt.Errorf("failed to get secrets: %v", err)
	}

	return &BuildContext{
		Job:                     job,
		GitHubInstallationToken: token,
		Workflow:                workflow,
		Secrets:                 secrets,
	}, nil
}

func connectSSHOnVM(vmName string, infoLogger *log.Logger) (*ssh.Client, error) {
	ip, err := GetVMIp(vmName, infoLogger)
	if nil != err {
		return nil, fmt.Errorf("error getting VM IP: %v", err)
	}
	return ConnectSSH(ip, infoLogger)
}

func convertSecretsToMap(secrets []Secret) map[string]string {
	secretMap := make(map[string]string)
	for _, secret := range secrets {
		secretMap[secret.Key] = secret.Value
	}
	return secretMap
}

func replaceEnvironmentVariables(command string, secrets map[string]string) string {
	result := command
	for key, value := range secrets {
		result = strings.ReplaceAll(result, "$"+key, value)
	}
	return result
}
