package main

import (
	"log"
	"testing"
)

func TestInitializeLoggers(t *testing.T) {
	infoLogger, errorLogger := InitializeLoggers()

	if infoLogger == nil {
		t.Error("infoLogger is nil")
		return
	}
	if errorLogger == nil {
		t.Error("errorLogger is nil")
		return
	}

	if infoLogger.Prefix() == "" {
		t.Error("infoLogger prefix is empty")
		return
	}
	if errorLogger.Prefix() == "" {
		t.Error("errorLogger prefix is empty")
		return
	}

	expectedFlags := log.LstdFlags | log.Lshortfile
	if infoLogger.Flags() != expectedFlags {
		t.Errorf("infoLogger flags mismatch. expected: %d, got: %d", expectedFlags, infoLogger.Flags())
		return
	}
	if errorLogger.Flags() != expectedFlags {
		t.Errorf("errorLogger flags mismatch. expected: %d, got: %d", expectedFlags, errorLogger.Flags())
		return
	}
}
