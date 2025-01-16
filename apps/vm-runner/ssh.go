package main

import (
	"bytes"
	"fmt"
	"log"
	"time"

	"golang.org/x/crypto/ssh"
)

type SSHClient struct {
	client     *ssh.Client
	logger     *log.Logger
	persistent bool
	session    *ssh.Session
}

func NewSSHClient(ip string, logger *log.Logger, persistent bool) (*SSHClient, error) {
	config := &ssh.ClientConfig{
		User: "admin",
		Auth: []ssh.AuthMethod{
			ssh.Password("admin"),
		},
		HostKeyCallback: ssh.InsecureIgnoreHostKey(),
		Timeout:         30 * time.Second,
	}

	client, err := ssh.Dial("tcp", fmt.Sprintf("%s:22", ip), config)
	if err != nil {
		return nil, fmt.Errorf("failed to dial: %v", err)
	}

	sshClient := &SSHClient{
		client:     client,
		logger:     logger,
		persistent: persistent,
	}

	if persistent {
		if err := sshClient.createPersistentSession(); err != nil {
			client.Close()
			return nil, err
		}
	}

	return sshClient, nil
}

func (s *SSHClient) createPersistentSession() error {
	session, err := s.client.NewSession()
	if err != nil {
		return fmt.Errorf("failed to create persistent session: %v", err)
	}

	if err := session.RequestPty("xterm", 80, 40, ssh.TerminalModes{
		ssh.ECHO:          0,
		ssh.TTY_OP_ISPEED: 14400,
		ssh.TTY_OP_OSPEED: 14400,
	}); err != nil {
		session.Close()
		return fmt.Errorf("failed to request pty: %v", err)
	}

	if err := session.Shell(); err != nil {
		session.Close()
		return fmt.Errorf("failed to start shell: %v", err)
	}

	s.session = session
	return nil
}

func (s *SSHClient) ExecuteCommand(command string) (string, error) {
	if s.persistent {
		return s.executePersistentCommand(command)
	}
	return s.executeOneTimeCommand(command)
}

func (s *SSHClient) executeOneTimeCommand(command string) (string, error) {
	session, err := s.client.NewSession()
	if err != nil {
		return "", fmt.Errorf("failed to create session: %v", err)
	}
	defer session.Close()

	output, err := session.CombinedOutput(command)
	if err != nil {
		return "", fmt.Errorf("failed to execute command: %v", err)
	}

	return string(output), nil
}

func (s *SSHClient) executePersistentCommand(command string) (string, error) {
	if s.session == nil {
		return "", fmt.Errorf("no persistent session available")
	}

	var stdout, stderr bytes.Buffer
	s.session.Stdout = &stdout
	s.session.Stderr = &stderr

	if err := s.session.Run(command); err != nil {
		return "", fmt.Errorf("failed to execute command: %v\nstderr: %s", err, stderr.String())
	}

	return stdout.String(), nil
}

func ConnectSSH(ip string, infoLogger *log.Logger) (*ssh.Client, error) {
	// デフォルトのSSH設定
	config := &ssh.ClientConfig{
		User: "admin",
		Auth: []ssh.AuthMethod{
			ssh.Password("admin"), // または適切なパスワード
		},
		HostKeyCallback: ssh.InsecureIgnoreHostKey(), // 注意: 本番環境では適切なホストキー検証を行うべき
		Timeout:         30 * time.Second,
	}

	// SSH接続を試行
	for i := 0; i < 30; i++ {
		client, err := ssh.Dial("tcp", fmt.Sprintf("%s:22", ip), config)
		if err == nil {
			infoLogger.Printf("Successfully connected to VM via SSH")
			return client, nil
		}

		infoLogger.Printf("Waiting for SSH connection... (attempt %d/30)", i+1)
		time.Sleep(2 * time.Second)
	}

	return nil, fmt.Errorf("failed to connect to VM via SSH after 30 attempts")
}

type SSHCommandResult struct {
	Stdout   string
	Stderr   string
	ExitCode int
	Command  string
}

func ExecuteSSHCommand(client *ssh.Client, command string, infoLogger *log.Logger) (SSHCommandResult, error) {
	if client == nil {
		return SSHCommandResult{}, fmt.Errorf("client is nil")
	}

	session, err := client.NewSession()
	if err != nil {
		return SSHCommandResult{}, fmt.Errorf("failed to create session: %v", err)
	}
	defer session.Close()

	var stdoutBuf, stderrBuf bytes.Buffer
	session.Stdout = &stdoutBuf
	session.Stderr = &stderrBuf

	runErr := session.Run(command)
	if runErr == nil {
		return SSHCommandResult{
			Stdout:   stdoutBuf.String(),
			Stderr:   stderrBuf.String(),
			ExitCode: 0,
			Command:  command,
		}, nil
	}

	exitCode := 0
	exitErr, ok := runErr.(*ssh.ExitError)
	if ok {
		exitCode = exitErr.ExitStatus()
	}

	return SSHCommandResult{
		Stdout:   stdoutBuf.String(),
		Stderr:   stderrBuf.String(),
		ExitCode: exitCode,
		Command:  command,
	}, fmt.Errorf("failed to execute command: %v", runErr)
}
