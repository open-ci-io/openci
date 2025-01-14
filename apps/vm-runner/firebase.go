package main

import (
	"context"
	"fmt"

	firebase "firebase.google.com/go"
)

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
