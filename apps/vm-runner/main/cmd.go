package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"time"

	firebase "firebase.google.com/go"
	"github.com/fatih/color"
	"github.com/getsentry/sentry-go"
	"github.com/urfave/cli/v3"
	"google.golang.org/api/option"
)

func main() {

	infoLogger := log.New(os.Stdout, color.GreenString("[INFO] "), log.LstdFlags|log.Lshortfile)
	errorLogger := log.New(os.Stderr, color.RedString("[ERROR] "), log.LstdFlags|log.Lshortfile)
	// warnLogger := log.New(os.Stdout, color.YellowString("[WARN] "), log.LstdFlags|log.Lshortfile)

	(&cli.Command{
		Name:  "vm-runner for OpenCI",
		Usage: "Run a VM Runner for OpenCI",
		Flags: []cli.Flag{
			&cli.StringFlag{
				Name:     "f",
				Usage:    "Path to Firebase Service Account Key JSON file",
				Required: true,
			},
			&cli.StringFlag{
				Name:     "s",
				Usage:    "Sentry DSN",
				Required: true,
			},
		},
		Action: func(ctx context.Context, cmd *cli.Command) error {

			sentryDSN := cmd.String("s")
			keyPath := cmd.String("f")

			if err := InitializeSentry(sentryDSN); err != nil {
				log.Fatalf("sentry initialization failed: %s", err)
			}

			// プログラム終了時にFlushされるように、main関数でdeferを設定
			defer sentry.Flush(2 * time.Second)

			opt := option.WithCredentialsFile(keyPath)
			app, err := firebase.NewApp(context.Background(), nil, opt)
			if err != nil {
				errorLogger.Printf("Error initializing app: %v", err)
				return fmt.Errorf("error initializing app: %v", err)
			}

			firestore, err := app.Firestore(ctx)
			if err != nil {
				sentry.CaptureMessage(fmt.Sprintf("error initializing firestore: %v", err))
				return fmt.Errorf("error initializing firestore: %v", err)
			}

			defer firestore.Close()

			for {
				infoLogger.Printf("Starting VM Runner with key path: %s", cmd.String("f"))

				buildJobsRef := firestore.Collection("build_jobs_v3").Limit(1)
				buildJobDocs, err := buildJobsRef.Documents(ctx).GetAll()
				if err != nil {
					sentry.CaptureMessage(fmt.Sprintf("error fetching build jobs: %v", err))
					return fmt.Errorf("error fetching build jobs: %v", err)
				}

				buildJobDoc := buildJobDocs[0]
				infoLogger.Printf("Processing build job: %v", buildJobDoc.Ref.ID)
				fmt.Printf("doc: %v\n", buildJobDoc.Data())

				secretsRef := firestore.Collection("secrets_v1")
				secretDocs, err := secretsRef.Documents(ctx).GetAll()
				if err != nil {
					sentry.CaptureMessage(fmt.Sprintf("error fetching secrets: %v", err))
					return fmt.Errorf("error fetching secrets: %v", err)
				}

				secretDoc := secretDocs[0]
				infoLogger.Printf("Found secret document: %v", secretDoc.Ref.ID)
				fmt.Printf("secretDoc: %v\n", secretDoc.Data())
				time.Sleep(1 * time.Second)
			}

		},
	}).Run(context.Background(), os.Args)
}
