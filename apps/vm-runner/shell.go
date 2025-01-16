package main

import (
	"fmt"
	"io"
	"os/exec"
	"strings"
)

type CommandResult struct {
	Command  string   // 実行されたコマンド
	Args     []string // コマンドの引数
	Stdout   string
	Stderr   string
	ExitCode int
}

func ExecuteCommand(command string, args ...string) (CommandResult, error) {
	cmd := exec.Command(command, args...)

	// 標準出力と標準エラー出力を分けて取得するためのパイプを作成
	stdout, err := cmd.StdoutPipe()
	if err != nil {
		return CommandResult{}, fmt.Errorf("failed to create stdout pipe: %v", err)
	}

	stderr, err := cmd.StderrPipe()
	if err != nil {
		return CommandResult{}, fmt.Errorf("failed to create stderr pipe: %v", err)
	}

	// コマンドを実行
	if err := cmd.Start(); err != nil {
		return CommandResult{}, fmt.Errorf("failed to start command: %v", err)
	}

	// 非同期で出力を読み取り
	stdoutBytes, err := io.ReadAll(stdout)
	if err != nil {
		return CommandResult{}, fmt.Errorf("failed to read stdout: %v", err)
	}

	stderrBytes, err := io.ReadAll(stderr)
	if err != nil {
		return CommandResult{}, fmt.Errorf("failed to read stderr: %v", err)
	}

	// コマンドの終了を待つ
	err = cmd.Wait()
	exitCode := 0
	if err != nil {
		if exitErr, ok := err.(*exec.ExitError); ok {
			exitCode = exitErr.ExitCode()
		}
	}

	fmt.Printf("Command: %s\n, Args: %v\n, Stdout: %s\n, Stderr: %s\n, ExitCode: %d", command, args, strings.TrimSpace(string(stdoutBytes)), strings.TrimSpace(string(stderrBytes)), exitCode)

	return CommandResult{
		Command:  command,
		Args:     args,
		Stdout:   strings.TrimSpace(string(stdoutBytes)),
		Stderr:   strings.TrimSpace(string(stderrBytes)),
		ExitCode: exitCode,
	}, nil
}
