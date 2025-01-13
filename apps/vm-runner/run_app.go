package main

import (
	"context"
	"fmt"
	"log"
	"time"

	firebase "firebase.google.com/go"
	"github.com/getsentry/sentry-go"
	"github.com/google/uuid"
	"github.com/urfave/cli/v3"
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
		infoLogger.Printf("Starting VM Runner with key path: %s", keyPath)
		if err := handleVMProcess(ctx, app, infoLogger, errorLogger); err != nil {
			errorLogger.Printf("VM Process failed, but continuing: %v", err)
			sentry.CaptureException(err)
		}

		time.Sleep(10 * time.Second)
	}
}

func handleVMProcess(ctx context.Context, app *firebase.App, infoLogger, errorLogger *log.Logger) error {
	vmName := uuid.New().String()
	buildId := uuid.New().String()
	logId := uuid.New().String()
	logPath := fmt.Sprintf("logs_v1/%s/%s/openci_log.log", buildId, logId)

	defer func() {
		cleanupVM(vmName, infoLogger)
	}()

	output, err := ExecuteCommand("tart", "clone", "sequoia", vmName)
	if err == nil && output.ExitCode == 0 {
		infoLogger.Printf("VM cloned: %s", vmName)
	} else {
		if nil != err {
			sentry.CaptureMessage(fmt.Sprintf("Command execution failed: %v", err))
			return fmt.Errorf("command execution failed: %v", err)
		}
		errorLogger.Printf("Command failed with exit code %d\nStderr: %s\n", output.ExitCode, output.Stderr)
		return fmt.Errorf("command failed with exit code %d", output.ExitCode)
	}

	StartVM(vmName, infoLogger)

	ip, ipErr := GetVMIp(vmName, infoLogger)
	if nil != ipErr {
		sentry.CaptureMessage(fmt.Sprintf("Error getting VM IP: %v", ipErr))
		return fmt.Errorf("error getting VM IP: %v", ipErr)
	}

	infoLogger.Printf("VM IP: %s", ip)

	client, sshErr := ConnectSSH(ip, infoLogger)
	if nil != sshErr {
		sentry.CaptureMessage(fmt.Sprintf("Error connecting to VM via SSH: %v", sshErr))
		return fmt.Errorf("error connecting to VM via SSH: %v", sshErr)
	}
	defer client.Close()

	infoLogger.Printf("Connected to VM via SSH")

	sshOutput, execErr := ExecuteSSHCommand(client, "lsa", infoLogger)

	sshLogContent := fmt.Sprintf(
		"Date: %s\nCommand: %s\nStdout: %s\nStderr: %s\nExitCode: %d\n",
		time.Now().Format(time.RFC3339),
		sshOutput.Command,
		sshOutput.Stdout,
		sshOutput.Stderr,
		sshOutput.ExitCode,
	)

	if execErr == nil {
		infoLogger.Printf("SSH command output: %+v", sshOutput)

		uploadErr := UploadLogToFirebaseStorage(ctx, app, logPath, sshLogContent)
		if nil != uploadErr {
			errorLogger.Printf("Failed to upload success log to Firebase Storage: %v", uploadErr)
		}
		return nil
	} else {
		fmt.Printf("Error executing SSH command: %v, %v", execErr, sshLogContent)
		sentry.CaptureMessage(sshLogContent)

		uploadErr := UploadLogToFirebaseStorage(ctx, app, logPath, sshLogContent)
		if nil != uploadErr {
			errorLogger.Printf("Failed to upload error log to Firebase Storage: %v", uploadErr)
		}
		return fmt.Errorf("error executing SSH command: %v", execErr)
	}
}

func cleanupVM(vmName string, infoLogger *log.Logger) {
	ExecuteCommand("tart", "stop", vmName)
	infoLogger.Printf("VM stopped: %s", vmName)

	ExecuteCommand("tart", "delete", vmName)
	infoLogger.Printf("VM deleted: %s", vmName)
}
