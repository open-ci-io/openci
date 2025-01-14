package main

import (
	"encoding/hex"
	"fmt"
	"log"
	"strings"
	"time"

	"github.com/getsentry/sentry-go"
)

func GetVMIp(vmName string, infoLogger *log.Logger) (string, error) {
	for {
		output, err := ExecuteCommand("tart", "ip", vmName)
		if err != nil {
			infoLogger.Printf("Error getting VM IP: %v", err)
			time.Sleep(1 * time.Second)
			continue
		}

		ip := strings.TrimSpace(output.Stdout)
		if ip != "" {
			return ip, nil
		}

		infoLogger.Printf("Waiting for VM to start...")
		time.Sleep(1 * time.Second)
	}
}

func cloneVM(vmName string, infoLogger *log.Logger, errorLogger *log.Logger) error {
	output, err := ExecuteCommand("tart", "clone", "sequoia", vmName)
	if err == nil && output.ExitCode == 0 {
		infoLogger.Printf("VM cloned: %s", vmName)
		return nil
	} else {
		if nil != err {
			sentry.CaptureMessage(fmt.Sprintf("Command execution failed: %v", err))
			return fmt.Errorf("command execution failed: %v", err)
		}
		errorLogger.Printf("Command failed with exit code %d\nStderr: %s\n", output.ExitCode, output.Stderr)
		return fmt.Errorf("command failed with exit code %d", output.ExitCode)
	}
}

func StartVM(vmName string, infoLogger *log.Logger, errorLogger *log.Logger) {
	cloneVM(vmName, infoLogger, errorLogger)
	// VM起動用のgoroutine
	go func() {
		output, err := ExecuteCommand("tart", "run", vmName)
		if err != nil {
			sentry.CaptureMessage(fmt.Sprintf("Failed to start VM: %v", err))
			return
		}
		if output.ExitCode != 0 {
			sentry.CaptureMessage(fmt.Sprintf("VM start failed with exit code %d: %s", output.ExitCode, output.Stderr))
		}
	}()

	// IP取得を待つ
	ip, err := GetVMIp(vmName, infoLogger)
	if err != nil {
		sentry.CaptureMessage(fmt.Sprintf("Failed to get VM IP: %v", err))
		return
	}

	infoLogger.Printf("VM started with IP: %s", ip)
}

func CleanupVMs(vmName string, infoLogger *log.Logger) {
	ExecuteCommand("tart", "stop", vmName)
	infoLogger.Printf("VM stopped: %s", vmName)

	cleanupAllStoppedVMs(infoLogger)
}

func deleteVM(vmName string, infoLogger *log.Logger) {
	ExecuteCommand("tart", "delete", vmName)
	infoLogger.Printf("VM deleted: %s", vmName)
}

func isValidUUID(uuid string) bool {
	segments := strings.Split(uuid, "-")
	if len(segments) != 5 {
		return false
	}

	lengths := []int{8, 4, 4, 4, 12}
	for i, segment := range segments {
		if len(segment) != lengths[i] {
			return false
		}
		// 16進数のみかチェック
		if _, err := hex.DecodeString(segment); err != nil {
			return false
		}
	}
	return true
}

func cleanupAllStoppedVMs(infoLogger *log.Logger) error {
	output, err := ExecuteCommand("tart", "list")
	if err != nil {
		return fmt.Errorf("failed to list VMs: %v", err)
	}

	lines := strings.Split(output.Stdout, "\n")
	for _, line := range lines {
		if !strings.Contains(line, "stopped") {
			continue
		}

		fields := strings.Fields(line)
		if len(fields) < 2 {
			continue
		}

		vmName := fields[1]
		if !isValidUUID(vmName) {
			infoLogger.Printf("Skipping non-UUID VM name: %s", vmName)
			continue
		}

		deleteVM(vmName, infoLogger)
	}

	return nil
}
