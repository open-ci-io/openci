package main

import (
	"context"
	"fmt"
	"io"
	"regexp"

	firebase "firebase.google.com/go"
)

func UploadLogToFirebaseStorage(
	ctx context.Context,
	app *firebase.App,
	jobId string,
	cmdRes SSHCommandResult,
) error {
	fmt.Printf("UploadLogToFirebaseStorage: %+v", cmdRes)
	fileName := logPath(jobId)
	fmt.Printf("fileName: %s", fileName)
	newContent := cmdLog(cmdRes)

	storageClient, err := app.Storage(ctx)
	if err != nil {
		return fmt.Errorf("failed to create storage client: %v", err)
	}

	bucket, err := storageClient.DefaultBucket()
	if err != nil {
		return fmt.Errorf("failed to get default storage bucket: %v", err)
	}

	obj := bucket.Object(fileName)
	reader, err := obj.NewReader(ctx)

	var content string
	if err == nil {
		existingContent, err := io.ReadAll(reader)
		reader.Close()
		if err != nil {
			return fmt.Errorf("failed to read existing log: %v", err)
		}
		content = string(existingContent) + "\n" + newContent
	} else {
		content = newContent
	}

	writer := obj.NewWriter(ctx)
	_, err = writer.Write([]byte(content))
	if err != nil {
		writer.Close()
		return fmt.Errorf("failed to write log to storage: %v", err)
	}

	if err = writer.Close(); err != nil {
		return fmt.Errorf("failed to close writer: %v", err)
	}

	return nil
}

func logPath(buildId string) string {
	return fmt.Sprintf("logs_v1/%s/openci_log.log", buildId)
}

func cmdLog(output SSHCommandResult) string {
	logContent := fmt.Sprintf(
		"=== Command Execution Result ===\n"+
			"Command: %s\n"+
			"Exit Code: %d\n"+
			"=== Stdout ===\n%s\n"+
			"=== Stderr ===\n%s\n"+
			"=========================",
		output.Command,
		output.ExitCode,
		output.Stdout,
		output.Stderr,
	)

	return redactSensitiveInfo(logContent)
}

func redactSensitiveInfo(input string) string {
	patterns := []struct {
		regex       string
		replacement string
	}{
		{`[A-Za-z0-9+/]{24,}={0,3}`, "REDACTED_BASE64"},
		{`(ghs_|github_)[0-9a-f]{40}`, "REDACTED_GITHUB_TOKEN"},
		{`[A-Za-z0-9_\-]{40,}`, "REDACTED_ACCESS_TOKEN"},
		{`(?i)password=([^\s&]+)`, "password=REDACTED_PASSWORD"},
	}

	result := input
	for _, pattern := range patterns {
		re := regexp.MustCompile(pattern.regex)
		result = re.ReplaceAllString(result, pattern.replacement)
	}
	return result
}
