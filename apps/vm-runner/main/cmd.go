package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"time"

	"cloud.google.com/go/firestore"
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

			firestoreClient, err := app.Firestore(ctx)
			if err != nil {
				sentry.CaptureMessage(fmt.Sprintf("error initializing firestore: %v", err))
				return fmt.Errorf("error initializing firestore: %v", err)
			}

			defer firestoreClient.Close()

			for {
				infoLogger.Printf("Starting VM Runner with key path: %s", cmd.String("f"))

				runFirestoreTransaction(ctx, firestoreClient, infoLogger)

				secretsRef := firestoreClient.Collection("secrets_v1")
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

func runFirestoreTransaction(ctx context.Context, firestoreClient *firestore.Client, infoLogger *log.Logger) error {
	return firestoreClient.RunTransaction(ctx, func(ctx context.Context, tx *firestore.Transaction) error {
		// build_jobs_v3コレクションからbuildStatus == "queued"のものをcreatedAtで昇順に並べ、1件のみ取得
		buildJobsRef := firestoreClient.Collection("build_jobs_v3").
			Where("buildStatus", "==", "queued").
			OrderBy("createdAt", firestore.Asc).
			Limit(1)

		buildJobDocs, err := buildJobsRef.Documents(ctx).GetAll()
		if err != nil {
			return fmt.Errorf("failed to fetch build jobs: %v", err)
		}

		// 該当ドキュメントが無い場合は早期リターン
		if len(buildJobDocs) == 0 {
			return nil
		}

		docRef := buildJobDocs[0].Ref
		freshDocSnap, err := tx.Get(docRef)
		if err != nil {
			return fmt.Errorf("failed to get document snapshot: %v", err)
		}

		// buildStatusが"queued"でなければ早期リターン
		freshStatus, ok := freshDocSnap.Data()["buildStatus"].(string)
		if !ok {
			return nil
		}
		if freshStatus == "queued" {
			// buildStatusを"inProgress"にし、updatedAtを更新
			err = tx.Update(docRef, []firestore.Update{
				{
					Path:  "buildStatus",
					Value: "inProgress",
				},
				{
					Path:  "updatedAt",
					Value: time.Now(),
				},
			})
			if err != nil {
				return fmt.Errorf("failed to update document: %v", err)
			}

			infoLogger.Printf("Document %s updated to inProgress.", docRef.ID)
		} else {
			return nil
		}

		return nil
	})
}
