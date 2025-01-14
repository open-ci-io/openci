package main

import (
	"context"
	"fmt"
	"log"
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
		if err := handleVMProcess(ctx, infoLogger, errorLogger, firestoreClient, cmd); err != nil {
			errorLogger.Printf("Runner failed, but continuing: %v", err)
			sentry.CaptureException(err)
		}

		time.Sleep(10 * time.Second)
	}
}

func handleVMProcess(ctx context.Context, infoLogger, errorLogger *log.Logger, firestoreClient *firestore.Client, cmd *cli.Command) error {
	//
	// buildId := uuid.New().String()
	// logId := uuid.New().String()
	// logPath := fmt.Sprintf("logs_v1/%s/%s/openci_log.log", buildId, logId)

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

	sshOutput, execErr := ExecuteSSHCommand(client, "lsa", infoLogger)

	if execErr == nil {
		infoLogger.Printf("SSH command output: %+v", sshOutput)
	} else {
		sentry.CaptureMessage(fmt.Sprintf("Error executing SSH command: %v, %+v", execErr, sshOutput))
		return fmt.Errorf("error executing SSH command: %v, %+v", execErr, sshOutput)
	}

	// 	uploadErr := UploadLogToFirebaseStorage(ctx, app, logPath, sshLogContent)
	// 	if nil != uploadErr {
	// 		errorLogger.Printf("Failed to upload success log to Firebase Storage: %v", uploadErr)
	// 	}
	// 	return nil
	// } else {
	// 	fmt.Printf("Error executing SSH command: %v, %v", execErr, sshLogContent)
	// 	sentry.CaptureMessage(sshLogContent)

	// 	uploadErr := UploadLogToFirebaseStorage(ctx, app, logPath, sshLogContent)
	// 	if nil != uploadErr {
	// 		errorLogger.Printf("Failed to upload error log to Firebase Storage: %v", uploadErr)
	// 	}
	// 	return fmt.Errorf("error executing SSH command: %v", execErr)
	// }
	return nil

}

type BuildContext struct {
	Job                     *BuildJob
	GitHubInstallationToken string
	Workflow                *Workflow
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

	return &BuildContext{
		Job:                     job,
		GitHubInstallationToken: token,
		Workflow:                workflow,
	}, nil
}

func connectSSHOnVM(vmName string, infoLogger *log.Logger) (*ssh.Client, error) {
	ip, err := GetVMIp(vmName, infoLogger)
	if nil != err {
		return nil, fmt.Errorf("error getting VM IP: %v", err)
	}
	return ConnectSSH(ip, infoLogger)
}
