package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"time"

	"cloud.google.com/go/firestore"
	"github.com/getsentry/sentry-go"
)

type BuildJob struct {
	ID     string `json:"id"`
	GitHub struct {
		RepoURL        string `json:"repositoryUrl"`
		InstallationId int    `json:"installationId"`
		AppId          int    `json:"appId"`
		BuildBranch    string `json:"buildBranch"`
	} `json:"github"`
	WorkflowId string `json:"workflowId"`
	Status     string `json:"status"`
}

func ParseBuildJob(jsonData []byte) (*BuildJob, error) {
	var job BuildJob

	err := json.Unmarshal(jsonData, &job)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal build job: %w", err)
	}

	fmt.Printf("Successfully parsed BuildJob: %v\n", job)

	return &job, nil
}

func GetBuildJob(ctx context.Context, firestoreClient *firestore.Client, infoLogger *log.Logger) (*BuildJob, error) {
	var snap *firestore.DocumentSnapshot

	err := firestoreClient.RunTransaction(ctx, func(ctx context.Context, tx *firestore.Transaction) error {
		ref := firestoreClient.Collection("build_jobs_v3").
			Where("buildStatus", "==", "queued").
			OrderBy("createdAt", firestore.Asc).
			Limit(1)

		docs, err := ref.Documents(ctx).GetAll()
		if err != nil {
			return fmt.Errorf("failed to fetch build jobs: %v", err)
		}

		if len(docs) == 0 {
			return fmt.Errorf("no queued build jobs found")
		}

		docRef := docs[0].Ref
		freshDocSnap, err := tx.Get(docRef)
		if err != nil {
			return fmt.Errorf("failed to get document snapshot: %v", err)
		}

		if !freshDocSnap.Exists() {
			return fmt.Errorf("document does not exist")
		}

		data := freshDocSnap.Data()
		freshStatus, ok := data["buildStatus"].(string)
		if !ok {
			return fmt.Errorf("invalid buildStatus field")
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
			return fmt.Errorf("build job status is not queued: %s", freshStatus)
		}

		snap = freshDocSnap
		return nil
	})

	if err != nil {
		return nil, err
	}

	if snap == nil {
		return nil, fmt.Errorf("no valid build job found")
	}

	data := snap.Data()

	jsonData, err := json.Marshal(data)
	if err != nil {
		return nil, fmt.Errorf("failed to marshal workflow data: %v", err)
	}

	job, err := ParseBuildJob(jsonData)
	if err == nil {
		infoLogger.Printf("Successfully parsed BuildJob: %v\n", job)
	} else {
		sentry.CaptureMessage(fmt.Sprintf("Failed to parse BuildJob: %v", err))
		return nil, fmt.Errorf("failed to parse BuildJob: %v", err)
	}

	return job, nil
}
