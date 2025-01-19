package main

import (
	"context"
	"crypto/x509"
	"encoding/base64"
	"encoding/pem"
	"fmt"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
	"time"

	"github.com/cidertool/asc-go/asc"
	"github.com/urfave/cli/v3"
	"software.sslmate.com/src/go-pkcs12"
)

func main() {

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
			&cli.StringFlag{
				Name:     "b",
				Usage:    "Firebase Storage Bucket Name",
				Required: true,
			},
			&cli.StringFlag{
				Name:     "app-store-key",
				Usage:    "Path to App Store Connect API Key (.p8)",
				Required: true,
			},
			&cli.StringFlag{
				Name:     "app-store-issuer",
				Usage:    "App Store Connect API Issuer ID",
				Required: true,
			},
			&cli.StringFlag{
				Name:     "app-store-key-id",
				Usage:    "App Store Connect API Key ID",
				Required: true,
			},
		},
		Action: func(ctx context.Context, cmd *cli.Command) error {
			return RunApp2(ctx, cmd)
			// return RunApp(ctx, cmd)
		},
	}).Run(context.Background(), os.Args)
}

func RunApp2(ctx context.Context, cmd *cli.Command) error {

	// appStoreClient, err := initAppStoreClient(cmd)
	// if err != nil {
	// 	return err
	// }

	// _, err = getProvisioningProfiles(ctx, appStoreClient)
	// if err != nil {
	// 	return err
	// }

	// err = getCertificateContent(ctx, appStoreClient)
	// if err != nil {
	// 	return err
	// }

	err := ConvertCertToP12(
		"/Users/masahiroaoki/Desktop/dist.cer",
		cmd.String("app-store-key"),
		"output.p12",
		"mementomori",
	)
	if err != nil {
		log.Fatalf("Failed to convert certificate: %v", err)
	}

	// k := &Keychain{
	// 	logger:   &StandardLogger{},
	// 	executor: &SecurityCommandExecutor{},
	// }

	// // キーチェーンの初期化
	// err2 := k.Initialize(KeychainOptions{
	// 	Password: "mypassword",
	// 	Timeout:  nil, // no timeout
	// })
	// if err2 != nil {
	// 	log.Fatal(err2)
	// }

	// // 証明書の追加
	// err = k.AddCertificates(CertificateOptions{
	// 	CertificatePaths: []string{
	// 		filepath.Join(os.Getenv("HOME"), "Library/MobileDevice/Certificates/*.p12"),
	// 	},
	// 	CertificatePassword: "certpass",
	// 	AllowedApplications: []string{"codesign", "productsign"},
	// })
	// if err != nil {
	// 	log.Fatal(err)
	// }

	return nil
}

func ConvertCertToP12(certPath string, keyPath string, p12Path string, password string) error {
	// 証明書の読み込み
	certBytes, err := os.ReadFile(certPath)
	if err != nil {
		return fmt.Errorf("failed to read certificate: %v", err)
	}

	var cert *x509.Certificate
	// まずPEMとしてデコードを試みる
	if block, _ := pem.Decode(certBytes); block != nil {
		cert, err = x509.ParseCertificate(block.Bytes)
	} else {
		// PEMデコードに失敗した場合は、DERとしてパースを試みる
		cert, err = x509.ParseCertificate(certBytes)
	}

	if err != nil {
		return fmt.Errorf("failed to parse certificate: %v", err)
	}

	// 秘密鍵の読み込み
	keyBytes, err := os.ReadFile(keyPath)
	if err != nil {
		return fmt.Errorf("failed to read private key: %v", err)
	}

	keyBlock, _ := pem.Decode(keyBytes)
	if keyBlock == nil {
		return fmt.Errorf("failed to decode private key PEM")
	}

	privateKey, err := x509.ParsePKCS8PrivateKey(keyBlock.Bytes)
	if err != nil {
		return fmt.Errorf("failed to parse private key: %v", err)
	}

	// Modern.Encodeを使用してP12を作成
	pfxData, err := pkcs12.Modern.Encode(privateKey, cert, nil, password)
	if err != nil {
		return fmt.Errorf("failed to encode P12: %v", err)
	}

	// P12ファイルの保存
	err = os.WriteFile(p12Path, pfxData, 0644)
	if err != nil {
		return fmt.Errorf("failed to write P12 file: %v", err)
	}

	return nil
}

func getCertificateContent(ctx context.Context, appStoreClient *asc.Client) error {
	certificates, _, err := appStoreClient.Provisioning.ListCertificates(
		ctx,
		&asc.ListCertificatesQuery{
			FilterCertificateType: []string{"DISTRIBUTION"},
		},
	)
	if err != nil {
		fmt.Println("Error listing certificates:", err)
		return err
	}

	fmt.Printf("Certificates: %+v\n", certificates)

	for _, cert := range certificates.Data {
		fmt.Printf("Certificate Type: %s\n", *cert.Attributes.CertificateType)
		fmt.Printf("Display Name: %s\n", *cert.Attributes.DisplayName)
		fmt.Printf("Serial Number: %s\n", *cert.Attributes.SerialNumber)
		fmt.Printf("Expiration Date: %s\n", *cert.Attributes.ExpirationDate)

		if cert.Attributes.CertificateContent != nil {
			certData, err := base64.StdEncoding.DecodeString(*cert.Attributes.CertificateContent)
			if err != nil {
				fmt.Printf("Error decoding certificate: %v\n", err)
				continue
			}

			fileName := fmt.Sprintf("distribution_cert_%s.cer", *cert.Attributes.SerialNumber)
			err = os.WriteFile(fileName, certData, 0644)
			if err != nil {
				fmt.Printf("Error saving certificate: %v\n", err)
				continue
			}
			fmt.Printf("Certificate saved to: %s\n", fileName)
		}
		fmt.Println("---")
	}
	return nil
}

type Keychain struct {
	path     string
	logger   Logger
	executor CommandExecutor
}

type KeychainOptions struct {
	Password string
	Timeout  *int
}

type CertificateOptions struct {
	CertificatePaths     []string
	CertificatePassword  string
	AllowedApplications  []string
	AllowAllApplications bool
	DisallowApplications bool
}

type CommandExecutor interface {
	Execute(command string, args ...string) error
}

type Logger interface {
	Info(message string)
}

// Initialize creates and sets up a new keychain
func (k *Keychain) Initialize(opts KeychainOptions) error {
	if k.path == "" {
		if err := k.generatePath(); err != nil {
			return fmt.Errorf("failed to generate path: %w", err)
		}
	}

	k.logger.Info(fmt.Sprintf("Initialize new keychain to store code signing certificates at %s", k.path))

	if err := k.create(opts.Password); err != nil {
		return fmt.Errorf("failed to create keychain: %w", err)
	}

	if err := k.setTimeout(opts.Timeout); err != nil {
		return fmt.Errorf("failed to set timeout: %w", err)
	}

	if err := k.makeDefault(); err != nil {
		return fmt.Errorf("failed to make default: %w", err)
	}

	if err := k.unlock(opts.Password); err != nil {
		return fmt.Errorf("failed to unlock: %w", err)
	}

	return nil
}

// AddCertificates adds p12 certificates to the keychain
func (k *Keychain) AddCertificates(opts CertificateOptions) error {
	if opts.AllowAllApplications && opts.DisallowApplications {
		return fmt.Errorf("cannot use both allow-all-applications and disallow-all-applications")
	}

	k.logger.Info(fmt.Sprintf("Add certificates to keychain %s", k.path))

	certPaths, err := k.findCertificatePaths(opts.CertificatePaths)
	if err != nil {
		return fmt.Errorf("failed to find certificate paths: %w", err)
	}

	if len(certPaths) == 0 {
		return fmt.Errorf("did not find any certificates from specified locations")
	}

	for _, certPath := range certPaths {
		if err := k.addCertificate(certPath, opts); err != nil {
			return fmt.Errorf("failed to add certificate %s: %w", certPath, err)
		}
	}

	return nil
}

// 内部メソッド
func (k *Keychain) generatePath() error {
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return err
	}

	keychainDir := filepath.Join(homeDir, "Library", "codemagic-cli-tools", "keychains")
	if err := os.MkdirAll(keychainDir, 0755); err != nil {
		return err
	}

	date := time.Now().Format("02-01-06")
	tempFile, err := os.CreateTemp(keychainDir, fmt.Sprintf("%s_*.keychain-db", date))
	if err != nil {
		return err
	}
	defer tempFile.Close()

	k.path = tempFile.Name()
	return nil
}

func (k *Keychain) create(password string) error {
	return k.executor.Execute("security", "create-keychain", "-p", password, k.path)
}

func (k *Keychain) setTimeout(timeout *int) error {
	args := []string{"set-keychain-settings"}
	if timeout != nil {
		args = append(args, "-t", fmt.Sprintf("%d", *timeout))
	}
	args = append(args, k.path)
	return k.executor.Execute("security", args...)
}

func (k *Keychain) makeDefault() error {
	return k.executor.Execute("security", "default-keychain", "-s", k.path)
}

func (k *Keychain) unlock(password string) error {
	return k.executor.Execute("security", "unlock-keychain", "-p", password, k.path)
}

func (k *Keychain) addCertificate(certPath string, opts CertificateOptions) error {
	k.logger.Info(fmt.Sprintf("Add certificate %s to keychain %s", certPath, k.path))

	// まずPKCS12形式で試行
	err := k.runAddCertificateProcess(certPath, opts, "pkcs12")
	if err != nil {
		if strings.Contains(err.Error(), "Unable to decode the provided data") ||
			strings.Contains(err.Error(), "The user name or passphrase you entered is not correct") {
			// OpenSSL形式で再試行
			return k.runAddCertificateProcess(certPath, opts, "openssl")
		}
		return err
	}
	return nil
}

func (k *Keychain) runAddCertificateProcess(certPath string, opts CertificateOptions, importFormat string) error {
	args := []string{
		"import", certPath,
		"-f", importFormat,
		"-k", k.path,
		"-P", opts.CertificatePassword,
	}

	if opts.AllowAllApplications {
		args = append(args, "-A")
	} else if !opts.DisallowApplications {
		for _, app := range opts.AllowedApplications {
			args = append(args, "-T", app)
		}
	}

	return k.executor.Execute("security", args...)
}

func (k *Keychain) findCertificatePaths(patterns []string) ([]string, error) {
	var paths []string
	for _, pattern := range patterns {
		matches, err := filepath.Glob(pattern)
		if err != nil {
			return nil, err
		}
		paths = append(paths, matches...)
	}
	return paths, nil
}

func initAppStoreClient(cmd *cli.Command) (*asc.Client, error) {
	keyID := cmd.String("app-store-key-id")
	issuerID := cmd.String("app-store-issuer")
	expiryDuration := 20 * time.Minute
	privateKey, err := os.ReadFile(cmd.String("app-store-key"))
	if err != nil {
		return nil, err
	}

	ascAuth, err := asc.NewTokenConfig(keyID, issuerID, expiryDuration, privateKey)
	if err != nil {
		return nil, err
	}
	appStoreClient := asc.NewClient(ascAuth.Client())
	return appStoreClient, nil
}

func getProvisioningProfiles(ctx context.Context, appStoreClient *asc.Client) (*asc.ProfilesResponse, error) {
	profiles, _, err := appStoreClient.Provisioning.ListProfiles(
		ctx,
		&asc.ListProfilesQuery{
			FilterProfileType: []string{"IOS_APP_STORE"},
			Include:           []string{"bundleId"},
		},
	)
	if err != nil {
		fmt.Println("Error listing profiles:", err)
		return nil, err
	}

	// bundle IDのマップを作成
	bundleIdMap := make(map[string]string)
	for _, included := range profiles.Included {
		if included.Type == "bundleIds" {
			bundleIdMap[included.BundleID().ID] = *included.BundleID().Attributes.IDentifier
		}
	}

	fmt.Printf("Profiles: %+v\n", profiles)
	for _, profile := range profiles.Data {
		fmt.Printf("---\n")
		fmt.Printf("Profile Name: %s\n", *profile.Attributes.Name)
		fmt.Printf("Profile Type: %s\n", *profile.Attributes.ProfileType)
		fmt.Printf("Expiration Date: %s\n", *profile.Attributes.ExpirationDate)

		// Relationships から bundle ID の情報を取得
		if profile.Relationships != nil && profile.Relationships.BundleID != nil {
			bundleIdRef := profile.Relationships.BundleID.Data.ID
			if actualBundleId, exists := bundleIdMap[bundleIdRef]; exists {
				fmt.Printf("Bundle ID: %s\n", actualBundleId)
			}
		}

		if profile.Attributes.ProfileContent != nil {
			profileData, err := base64.StdEncoding.DecodeString(*profile.Attributes.ProfileContent)
			if err != nil {
				fmt.Printf("Error decoding profile: %v\n", err)
				continue
			}

			fileName := fmt.Sprintf("%s.mobileprovision", *profile.Attributes.UUID)
			err = os.WriteFile(fileName, profileData, 0644)
			if err != nil {
				fmt.Printf("Error saving profile: %v\n", err)
				continue
			}
			fmt.Printf("Profile saved to: %s\n", fileName)
		}
		fmt.Println("---")
	}

	return profiles, nil
}

type StandardLogger struct{}

func (s *StandardLogger) Info(message string) {
	log.Printf("[INFO] %s", message)
}

type SecurityCommandExecutor struct{}

func (sce *SecurityCommandExecutor) Execute(command string, args ...string) error {
	cmd := exec.Command(command, args...)
	// 必要に応じてログなどを追加
	return cmd.Run()
}
