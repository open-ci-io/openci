package main

import (
	"fmt"

	"github.com/getsentry/sentry-go"
)

func InitializeSentry(sentryDSN string) error {
	err := sentry.Init(sentry.ClientOptions{
		Dsn:              sentryDSN,
		TracesSampleRate: 1.0,
	})

	if err != nil {
		return fmt.Errorf("failed to initialize sentry: %w", err)
	}

	return nil
}
