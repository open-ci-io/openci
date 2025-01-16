package main

import (
	"context"
	"encoding/json"
	"fmt"

	"cloud.google.com/go/firestore"
)

type Secret struct {
	Key   string `json:"key"`
	Value string `json:"value"`
}

func GetSecrets(owners []string, firestoreClient *firestore.Client, ctx context.Context) ([]Secret, error) {
	ref := firestoreClient.Collection("secrets_v1").Where("owners", "array-contains-any", owners)
	docs, err := ref.Documents(ctx).GetAll()
	if err != nil {
		return nil, fmt.Errorf("failed to get secrets: %v", err)
	}

	secrets := make([]Secret, 0, len(docs))
	for _, doc := range docs {
		data, err := json.Marshal(doc.Data())
		if err != nil {
			return nil, fmt.Errorf("failed to marshal document data: %v", err)
		}

		secret, err := ParseSecrets(data)
		if err != nil {
			return nil, fmt.Errorf("failed to parse secret: %v", err)
		}
		secrets = append(secrets, *secret)
	}

	return secrets, nil
}

func ParseSecrets(jsonData []byte) (*Secret, error) {
	var secrets Secret

	err := json.Unmarshal(jsonData, &secrets)
	if err != nil {
		return nil, fmt.Errorf("failed to unmarshal secrets: %w", err)
	}

	fmt.Printf("Successfully parsed Workflow: %v\n", secrets)

	return &secrets, nil
}
