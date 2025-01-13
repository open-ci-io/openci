package main

import (
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

// メインの処理でVM起動とIP取得を非同期で行う例
func StartVM(vmName string, infoLogger *log.Logger) {
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
