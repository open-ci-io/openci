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

	infoLogger, errorLogger := InitializeLoggers()

	if err := InitializeSentry(sentryDSN); nil != err {
		log.Fatalf("Sentry initialization failed: %s", err)
	}
	defer sentry.Flush(2 * time.Second)

	opt := option.WithCredentialsFile(keyPath)
	app, err := firebase.NewApp(context.Background(), nil, opt)
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
		if err := handleVMProcess(infoLogger, errorLogger); nil != err {
			return err
		}
		time.Sleep(10 * time.Second)
		time.Sleep(10 * time.Second)
	}
}

func handleVMProcess(infoLogger, errorLogger *log.Logger) error {
	vmName := uuid.New().String()

	output, err := ExecuteCommand("tart", "clone", "sequoia", vmName)
	if nil != err {
		sentry.CaptureMessage(fmt.Sprintf("Command execution failed: %v", err))
		return fmt.Errorf("command execution failed: %v", err)
	}
	if output.ExitCode != 0 {
		errorLogger.Printf("Command failed with exit code %d\nStderr: %s\n", output.ExitCode, output.Stderr)
		return fmt.Errorf("command failed with exit code %d", output.ExitCode)
	}
	infoLogger.Printf("VM cloned: %s", vmName)

	StartVM(vmName, infoLogger)

	ip, ipErr := GetVMIp(vmName, infoLogger)
	if nil != ipErr {
		sentry.CaptureMessage(fmt.Sprintf("error getting VM IP: %v", ipErr))
		return fmt.Errorf("error getting VM IP: %v", ipErr)
	}
	infoLogger.Printf("VM IP: %s", ip)

	client, sshErr := ConnectSSH(ip, infoLogger)
	if nil != sshErr {
		sentry.CaptureMessage(fmt.Sprintf("error connecting to VM via SSH: %v", sshErr))
		return fmt.Errorf("error connecting to VM via SSH: %v", sshErr)
	}
	defer client.Close()

	infoLogger.Printf("Connected to VM via SSH")

	output2, execErr := ExecuteSSHCommand(client, "ls", infoLogger)
	if nil != execErr {
		sentry.CaptureMessage(fmt.Sprintf("Error executing SSH command: %v", execErr))
		return fmt.Errorf("error executing SSH command: %v", execErr)
	}
	infoLogger.Printf("SSH command output: %s", output2)

	return nil
}
