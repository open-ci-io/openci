package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"cloud.google.com/go/firestore"
)

func RunFirestoreTransaction(ctx context.Context, firestoreClient *firestore.Client, infoLogger *log.Logger) (*firestore.DocumentSnapshot, error) {
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
