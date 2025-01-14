package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go"
)

func GetWorkflow(ctx context.Context, firestoreClient *firestore.Client, workflowId string) (*firestore.DocumentSnapshot, error) {
	workflowRef := firestoreClient.Collection("workflows").Doc(workflowId)
	workflowSnap, err := workflowRef.Get(ctx)
	if err != nil {
		return nil, fmt.Errorf("failed to get workflow: %v", err)
	}
	return workflowSnap, nil
}

func GetBuildJob(ctx context.Context, firestoreClient *firestore.Client, infoLogger *log.Logger) (*firestore.DocumentSnapshot, error) {
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
			return fmt.Errorf("no queued build jobs found")
		}

		docRef := buildJobDocs[0].Ref
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

		resultSnap = freshDocSnap
		return nil
	})

	if err != nil {
		return nil, err
	}

	if resultSnap == nil {
		return nil, fmt.Errorf("no valid build job found")
	}

	return resultSnap, nil
}

// Firebase Storage へログをアップロードする専用メソッド
func UploadLogToFirebaseStorage(ctx context.Context, app *firebase.App, fileName string, content string) error {
	storageClient, err := app.Storage(ctx)
	if nil != err {
		return fmt.Errorf("failed to create storage client: %v", err)
	}

	bucket, err := storageClient.DefaultBucket()
	if nil != err {
		return fmt.Errorf("failed to get default storage bucket: %v", err)
	}

	writer := bucket.Object(fileName).NewWriter(ctx)
	_, writeErr := writer.Write([]byte(content))
	if nil != writeErr {
		writer.Close()
		return fmt.Errorf("failed to write log to storage: %v", writeErr)
	}

	closeErr := writer.Close()
	if nil != closeErr {
		return fmt.Errorf("failed to close writer: %v", closeErr)
	}

	return nil
}
