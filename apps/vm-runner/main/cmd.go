package main

import (
	"bytes"
	"context"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"os/exec"
	"strings"
	"time"

	"encoding/json"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go"
	"github.com/dgrijalva/jwt-go"
	"github.com/fatih/color"
	"github.com/getsentry/sentry-go"
	"github.com/google/uuid"
	"github.com/urfave/cli/v3"
	"golang.org/x/crypto/ssh"
	"google.golang.org/api/option"
)

type CommandResult struct {
	Command  string   // 実行されたコマンド
	Args     []string // コマンドの引数
	Stdout   string
	Stderr   string
	ExitCode int
}

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

func (s *SSHClient) Close() error {
	if s.persistent && s.session != nil {
		s.session.Close()
	}
	return s.client.Close()
}

func main() {

	infoLogger := log.New(os.Stdout, color.GreenString("[INFO] "), log.LstdFlags|log.Lshortfile)
	errorLogger := log.New(os.Stderr, color.RedString("[ERROR] "), log.LstdFlags|log.Lshortfile)
	// warnLogger := log.New(os.Stdout, color.YellowString("[WARN] "), log.LstdFlags|log.Lshortfile)

	(&cli.Command{
		Name:  "vm-runner for OpenCI",
		Usage: "Run a VM Runner for OpenCI",
		Flags: []cli.Flag{
			&cli.StringFlag{
				Name:     "f",
				Usage:    "Path to Firebase Service Account Key JSON file",
				Required: true,
			},
			&cli.StringFlag{
				Name:     "s",
				Usage:    "Sentry DSN",
				Required: true,
			},
			&cli.StringFlag{
				Name:     "p",
				Usage:    "GitHub App's .pem",
				Required: true,
			},
		},
		Action: func(ctx context.Context, cmd *cli.Command) error {

			sentryDSN := cmd.String("s")
			keyPath := cmd.String("f")
			// pemPath := cmd.String("p")

			if err := InitializeSentry(sentryDSN); err != nil {
				log.Fatalf("sentry initialization failed: %s", err)
			}

			// プログラム終了時にFlushされるように、main関数でdeferを設定
			defer sentry.Flush(2 * time.Second)

			opt := option.WithCredentialsFile(keyPath)
			app, err := firebase.NewApp(context.Background(), nil, opt)
			if err != nil {
				errorLogger.Printf("Error initializing app: %v", err)
				return fmt.Errorf("error initializing app: %v", err)
			}

			firestoreClient, err := app.Firestore(ctx)
			if err != nil {
				sentry.CaptureMessage(fmt.Sprintf("error initializing firestore: %v", err))
				return fmt.Errorf("error initializing firestore: %v", err)
			}

			defer firestoreClient.Close()

			for {
				infoLogger.Printf("Starting VM Runner with key path: %s", cmd.String("f"))

				vmName := uuid.New().String()

				output, err := executeCommand("tart", "clone", "sequoia", vmName)
				if err != nil {
					sentry.CaptureMessage(fmt.Sprintf("command execution failed: %v", err))
					return fmt.Errorf("command execution failed: %v", err)
				}
				if output.ExitCode != 0 {
					// コマンドは実行されたが、エラーで終了した場合の処理
					errorLogger.Printf("Command failed with exit code %d\nStderr: %s\n", output.ExitCode, output.Stderr)
					return fmt.Errorf("command failed with exit code %d", output.ExitCode)
				}
				infoLogger.Printf("VM cloned: %s", vmName)

				startVM(vmName, infoLogger)

				ip, err := getVMIp(vmName, infoLogger)
				if err != nil {
					sentry.CaptureMessage(fmt.Sprintf("error getting VM IP: %v", err))
					return fmt.Errorf("error getting VM IP: %v", err)
				}
				infoLogger.Printf("VM IP: %s", ip)

				client, err := connectSSH(ip, infoLogger)
				if err != nil {
					sentry.CaptureMessage(fmt.Sprintf("error connecting to VM via SSH: %v", err))
					return fmt.Errorf("error connecting to VM via SSH: %v", err)
				}

				defer client.Close()

				infoLogger.Printf("Connected to VM via SSH")

				output2, err := executeSSHCommand(client, "ls", infoLogger)
				if err != nil {
					sentry.CaptureMessage(fmt.Sprintf("error executing SSH command: %v", err))
					return fmt.Errorf("error executing SSH command: %v", err)
				}
				infoLogger.Printf("SSH command output: %s", output2)

				// execOutput, err := executeSSHCommand(client, "ls -la")
				// if err != nil {
				// 	sentry.CaptureMessage(fmt.Sprintf("error executing SSH command: %v", err))
				// 	return fmt.Errorf("error executing SSH command: %v", err)
				// }
				// infoLogger.Printf("SSH command output: %s", execOutput)

				time.Sleep(10 * time.Second)

				// buildJobSnap, err := runFirestoreTransaction(ctx, firestoreClient, infoLogger)
				// if err != nil {
				// 	sentry.CaptureMessage(fmt.Sprintf("error running firestore transaction: %v", err))
				// 	return fmt.Errorf("error running firestore transaction: %v", err)
				// }

				// if buildJobSnap == nil {
				// 	infoLogger.Printf("No valid document found.")
				// 	time.Sleep(1 * time.Second)
				// 	continue
				// }

				// buildJob := buildJobSnap.Data()
				// infoLogger.Printf("Found build job document: %v", buildJobSnap.Ref.ID)

				// workflowSnaps, err := firestoreClient.Collection("workflows").Documents(ctx).GetAll()
				// if err != nil {
				// 	sentry.CaptureMessage(fmt.Sprintf("error fetching workflows: %v", err))
				// 	return fmt.Errorf("error fetching workflows: %v", err)
				// }

				// infoLogger.Printf("Found workflowSnaps: %v", workflowSnaps)

				// github := buildJob["github"].(map[string]interface{})

				// installationToken, err := getGitHubInstallationToken(pemPath, github["installationId"].(int64), github["appId"].(int64))
				// if err != nil {
				// 	sentry.CaptureMessage(fmt.Sprintf("error getting GitHub installation token: %v", err))
				// 	return fmt.Errorf("error getting GitHub installation token: %v", err)
				// }

				// infoLogger.Printf("Installation token: %s", installationToken)

				// fmt.Printf("buildJob: %v\n", buildJob)
				time.Sleep(10 * time.Second)
			}

		},
	}).Run(context.Background(), os.Args)
}

func connectSSH(ip string, infoLogger *log.Logger) (*ssh.Client, error) {
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

// SSHセッションでコマンドを実行する補助関数
func executeSSHCommand(client *ssh.Client, command string, infoLogger *log.Logger) (string, error) {
	session, err := client.NewSession()
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

func getGitHubInstallationToken(pemPath string, installationID int64, appID int64) (string, error) {
	pemBytes, err := os.ReadFile(pemPath)
	if err != nil {
		return "", fmt.Errorf("failed to read pem file: %v", err)
	}

	privateKey, err := jwt.ParseRSAPrivateKeyFromPEM(pemBytes)
	if err != nil {
		return "", fmt.Errorf("failed to parse private key: %v", err)
	}

	now := time.Now()
	claims := jwt.StandardClaims{
		IssuedAt:  now.Unix(),
		ExpiresAt: now.Add(9 * time.Minute).Unix(),
		Issuer:    fmt.Sprintf("%d", appID),
	}

	jwtToken, err := jwt.NewWithClaims(jwt.SigningMethodRS256, claims).SignedString(privateKey)
	if err != nil {
		return "", fmt.Errorf("failed to sign jwt: %v", err)
	}

	url := fmt.Sprintf("https://api.github.com/app/installations/%d/access_tokens", installationID)
	req, err := http.NewRequest("POST", url, nil)
	if err != nil {
		return "", fmt.Errorf("failed to create request for installation token: %v", err)
	}
	req.Header.Set("Authorization", fmt.Sprintf("Bearer %s", jwtToken))
	req.Header.Set("Accept", "application/vnd.github.v3+json")

	client := &http.Client{Timeout: 10 * time.Second}
	resp, err := client.Do(req)
	if err != nil {
		return "", fmt.Errorf("failed to request GitHub installation token: %v", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusCreated {
		return "", fmt.Errorf("failed to get installation token, status code: %d", resp.StatusCode)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", fmt.Errorf("failed to read response body: %v", err)
	}

	var tokenResponse struct {
		Token string `json:"token"`
	}
	if err := json.Unmarshal(body, &tokenResponse); err != nil {
		return "", fmt.Errorf("failed to unmarshal token response: %v", err)
	}

	if len(tokenResponse.Token) == 0 {
		return "", fmt.Errorf("installation token not found in response")
	}

	return tokenResponse.Token, nil
}

func runFirestoreTransaction(ctx context.Context, firestoreClient *firestore.Client, infoLogger *log.Logger) (*firestore.DocumentSnapshot, error) {
	var resultSnap *firestore.DocumentSnapshot

	err := firestoreClient.RunTransaction(ctx, func(ctx context.Context, tx *firestore.Transaction) error {
		buildJobsRef := firestoreClient.Collection("build_jobs_v3").
			Where("buildStatus", "==", "queued").
			OrderBy("createdAt", firestore.Asc).
			Limit(1)

		buildJobDocs, err := buildJobsRef.Documents(ctx).GetAll()
		if err != nil {
			return fmt.Errorf("failed to fetch build jobs: %v", err)
		}

		if len(buildJobDocs) == 0 {
			return nil
		}

		docRef := buildJobDocs[0].Ref
		freshDocSnap, err := tx.Get(docRef)
		if err != nil {
			return fmt.Errorf("failed to get document snapshot: %v", err)
		}

		freshStatus, ok := freshDocSnap.Data()["buildStatus"].(string)
		if !ok {
			resultSnap = freshDocSnap
			return nil
		}

		if freshStatus == "queued" {
			err = tx.Update(docRef, []firestore.Update{
				{
					Path:  "buildStatus",
					Value: "inProgress",
				},
				{
					Path:  "updatedAt",
					Value: time.Now(),
				},
			})
			if err != nil {
				return fmt.Errorf("failed to update document: %v", err)
			}
			infoLogger.Printf("Document %s updated to inProgress.", docRef.ID)
		} else {
			resultSnap = nil
			return nil
		}

		resultSnap = freshDocSnap
		return nil
	})

	if err != nil {
		return nil, err
	}

	return resultSnap, nil
}

func executeCommand(command string, args ...string) (CommandResult, error) {
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

func getVMIp(vmName string, infoLogger *log.Logger) (string, error) {
	for {
		output, err := executeCommand("tart", "ip", vmName)
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
func startVM(vmName string, infoLogger *log.Logger) {
	// VM起動用のgoroutine
	go func() {
		output, err := executeCommand("tart", "run", vmName)
		if err != nil {
			sentry.CaptureMessage(fmt.Sprintf("Failed to start VM: %v", err))
			return
		}
		if output.ExitCode != 0 {
			sentry.CaptureMessage(fmt.Sprintf("VM start failed with exit code %d: %s", output.ExitCode, output.Stderr))
		}
	}()

	// IP取得を待つ
	ip, err := getVMIp(vmName, infoLogger)
	if err != nil {
		sentry.CaptureMessage(fmt.Sprintf("Failed to get VM IP: %v", err))
		return
	}

	infoLogger.Printf("VM started with IP: %s", ip)
}
