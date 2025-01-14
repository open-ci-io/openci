package main

import (
	"context"
	"encoding/json"
	"fmt"

	"cloud.google.com/go/firestore"
)

type Workflow struct {
	ID                      string `json:"id"`
	CurrentWorkingDirectory string `json:"currentWorkingDirectory"`
}

func GetWorkflow(ctx context.Context, firestoreClient *firestore.Client, workflowId string) (*Workflow, error) {
	ref := firestoreClient.Collection("workflows").Doc(workflowId)
	docs, err := ref.Get(ctx)
	if err != nil {
		return nil, fmt.Errorf("failed to get workflow: %v", err)
	}
	data := docs.Data()
	jsonData, err := json.Marshal(data)
	if err != nil {
		return nil, fmt.Errorf("failed to marshal workflow data: %v", err)
	}
	workflow, err := ParseWorkflow(jsonData)
	if err != nil {
		return nil, fmt.Errorf("failed to parse workflow: %v", err)
	}
	return workflow, nil
}

func ParseWorkflow(jsonData []byte) (*Workflow, error) {
	var workflow Workflow

	err := json.Unmarshal(jsonData, &workflow)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal workflow: %w", err)
	}

	fmt.Printf("Successfully parsed Workflow: %v\n", workflow)

	return &workflow, nil
}
