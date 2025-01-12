package main

import (
	"context"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"time"

	"encoding/json"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go"
	"github.com/dgrijalva/jwt-go"
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
			&cli.StringFlag{
				Name:     "p",
				Usage:    "GitHub App's .pem",
				Required: true,
			},
		},
		Action: func(ctx context.Context, cmd *cli.Command) error {

			sentryDSN := cmd.String("s")
			keyPath := cmd.String("f")
			pemPath := cmd.String("p")

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

				buildJobSnap, err := runFirestoreTransaction(ctx, firestoreClient, infoLogger)
				if err != nil {
					sentry.CaptureMessage(fmt.Sprintf("error running firestore transaction: %v", err))
					return fmt.Errorf("error running firestore transaction: %v", err)
				}

				if buildJobSnap == nil {
					infoLogger.Printf("No valid document found.")
					time.Sleep(1 * time.Second)
					continue
				}

				buildJob := buildJobSnap.Data()
				infoLogger.Printf("Found build job document: %v", buildJobSnap.Ref.ID)

				workflowSnaps, err := firestoreClient.Collection("workflows").Documents(ctx).GetAll()
				if err != nil {
					sentry.CaptureMessage(fmt.Sprintf("error fetching workflows: %v", err))
					return fmt.Errorf("error fetching workflows: %v", err)
				}

				infoLogger.Printf("Found workflowSnaps: %v", workflowSnaps)

				github := buildJob["github"].(map[string]interface{})

				installationToken, err := getGitHubInstallationToken(pemPath, github["installationId"].(int64), github["appId"].(int64))
				if err != nil {
					sentry.CaptureMessage(fmt.Sprintf("error getting GitHub installation token: %v", err))
					return fmt.Errorf("error getting GitHub installation token: %v", err)
				}

				infoLogger.Printf("Installation token: %s", installationToken)

				fmt.Printf("buildJob: %v\n", buildJob)
				time.Sleep(1 * time.Second)
			}

		},
	}).Run(context.Background(), os.Args)
}

func getGitHubInstallationToken(pemPath string, installationID int64, appID int64) (string, error) {
	pemBytes, err := os.ReadFile(pemPath)
	if err != nil {
		return "", fmt.Errorf("failed to read pem file: %v", err)
	}

	privateKey, err := jwt.ParseRSAPrivateKeyFromPEM(pemBytes)
	if err != nil {
		return "", fmt.Errorf("failed to parse private key: %v", err)
	}

	now := time.Now()
	claims := jwt.StandardClaims{
		IssuedAt:  now.Unix(),
		ExpiresAt: now.Add(9 * time.Minute).Unix(),
		Issuer:    fmt.Sprintf("%d", appID),
	}

	jwtToken, err := jwt.NewWithClaims(jwt.SigningMethodRS256, claims).SignedString(privateKey)
	if err != nil {
		return "", fmt.Errorf("failed to sign jwt: %v", err)
	}

	url := fmt.Sprintf("https://api.github.com/app/installations/%d/access_tokens", installationID)
	req, err := http.NewRequest("POST", url, nil)
	if err != nil {
		return "", fmt.Errorf("failed to create request for installation token: %v", err)
	}
	req.Header.Set("Authorization", fmt.Sprintf("Bearer %s", jwtToken))
	req.Header.Set("Accept", "application/vnd.github.v3+json")

	client := &http.Client{Timeout: 10 * time.Second}
	resp, err := client.Do(req)
	if err != nil {
		return "", fmt.Errorf("failed to request GitHub installation token: %v", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusCreated {
		return "", fmt.Errorf("failed to get installation token, status code: %d", resp.StatusCode)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", fmt.Errorf("failed to read response body: %v", err)
	}

	var tokenResponse struct {
		Token string `json:"token"`
	}
	if err := json.Unmarshal(body, &tokenResponse); err != nil {
		return "", fmt.Errorf("failed to unmarshal token response: %v", err)
	}

	if len(tokenResponse.Token) == 0 {
		return "", fmt.Errorf("installation token not found in response")
	}

	return tokenResponse.Token, nil
}

func runFirestoreTransaction(ctx context.Context, firestoreClient *firestore.Client, infoLogger *log.Logger) (*firestore.DocumentSnapshot, error) {
	var resultSnap *firestore.DocumentSnapshot

	err := firestoreClient.RunTransaction(ctx, func(ctx context.Context, tx *firestore.Transaction) error {
		buildJobsRef := firestoreClient.Collection("build_jobs_v3").
			Where("buildStatus", "==", "queued").
			OrderBy("createdAt", firestore.Asc).
			Limit(1)

		buildJobDocs, err := buildJobsRef.Documents(ctx).GetAll()
		if err != nil {
			return fmt.Errorf("failed to fetch build jobs: %v", err)
		}

		if len(buildJobDocs) == 0 {
			return nil
		}

		docRef := buildJobDocs[0].Ref
		freshDocSnap, err := tx.Get(docRef)
		if err != nil {
			return fmt.Errorf("failed to get document snapshot: %v", err)
		}

		freshStatus, ok := freshDocSnap.Data()["buildStatus"].(string)
		if !ok {
			resultSnap = freshDocSnap
			return nil
		}

		if freshStatus == "queued" {
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
			resultSnap = nil
			return nil
		}

		resultSnap = freshDocSnap
		return nil
	})

	if err != nil {
		return nil, err
	}

	return resultSnap, nil
}
