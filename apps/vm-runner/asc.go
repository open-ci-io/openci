package main

import (
	"context"
	"encoding/base64"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/cidertool/asc-go/asc"
	"github.com/urfave/cli/v3"
	"golang.org/x/crypto/ssh"
)

func InitAppStoreClient(cmd *cli.Command) (*asc.Client, error) {
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

func GetProvisioningProfiles(ctx context.Context, appStoreClient *asc.Client) (*asc.ProfilesResponse, error) {
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

		fmt.Println("---")
	}

	return profiles, nil
}

func GetCertificateContent(
	ctx context.Context,
	appStoreClient *asc.Client,
	client *ssh.Client,
	infoLogger *log.Logger,
	appStoreKeyPath string,
) error {
	certificates, _, err := appStoreClient.Provisioning.ListCertificates(
		ctx,
		&asc.ListCertificatesQuery{
			FilterCertificateType: []string{"DISTRIBUTION"},
		},
	)
	if err != nil {
		return fmt.Errorf("failed to list certificates: %v", err)
	}

	if len(certificates.Data) == 0 {
		return fmt.Errorf("no distribution certificates found")
	}

	cert := certificates.Data[0]
	if cert.Attributes.CertificateContent == nil {
		return fmt.Errorf("certificate content is nil")
	}

	certData, err := base64.StdEncoding.DecodeString(*cert.Attributes.CertificateContent)
	if err != nil {
		return fmt.Errorf("failed to decode certificate content: %v", err)
	}

	// 一時的な.cerファイルを作成
	tempCertPath := fmt.Sprintf("/tmp/%s.cer", *cert.Attributes.SerialNumber)
	if err := os.WriteFile(tempCertPath, certData, 0644); err != nil {
		return fmt.Errorf("failed to write temporary certificate: %v", err)
	}
	defer os.Remove(tempCertPath)

	// .p12ファイルのパスを設定
	p12Path := fmt.Sprintf("/Users/admin/Library/MobileDevice/Certificates/%s.p12", *cert.Attributes.SerialNumber)

	// .cerから.p12に変換
	err = ConvertCertToP12(
		tempCertPath,
		appStoreKeyPath,
		p12Path,
		"mementomori", // TODO: パスワードは設定可能にする
	)
	if err != nil {
		return fmt.Errorf("failed to convert certificate to p12: %v", err)
	}

	// 証明書を保存するディレクトリを作成
	mkdirCmd := "mkdir -p '/Users/admin/Library/MobileDevice/Certificates/'"
	output, err := ExecuteSSHCommand(client, mkdirCmd, infoLogger)
	if err != nil {
		return fmt.Errorf("failed to create certificates directory: %v", err)
	}
	infoLogger.Printf("Successfully created certificates directory: %v", output)

	// .p12ファイルをbase64エンコード
	p12Data, err := os.ReadFile(p12Path)
	if err != nil {
		return fmt.Errorf("failed to read p12 file: %v", err)
	}
	encodedP12 := base64.StdEncoding.EncodeToString(p12Data)

	// リモートマシンに.p12ファイルを保存
	saveCmd := fmt.Sprintf("echo '%s' | base64 -D > '%s'", encodedP12, p12Path)
	output, err = ExecuteSSHCommand(client, saveCmd, infoLogger)
	if err != nil {
		infoLogger.Printf("Failed to save p12: %v", output)
		return fmt.Errorf("failed to save p12: %v", err)
	}
	infoLogger.Printf("Successfully saved p12: %v", output)

	return nil
}
