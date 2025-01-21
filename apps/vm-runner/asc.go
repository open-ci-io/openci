package main

import (
	"bytes"
	"context"
	"crypto/rand"
	"crypto/rsa"
	"crypto/x509"
	"crypto/x509/pkix"
	"encoding/base64"
	"encoding/pem"
	"fmt"
	"io/ioutil"
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
	p12Path string,
) error {
	// certificates, _, err := appStoreClient.Provisioning.ListCertificates(
	// 	ctx,
	// 	&asc.ListCertificatesQuery{
	// 		FilterCertificateType: []string{"DISTRIBUTION"},
	// 	},
	// )
	// if err != nil {
	// 	return fmt.Errorf("failed to list certificates: %v", err)
	// }

	// if len(certificates.Data) == 0 {
	// 	return fmt.Errorf("no distribution certificates found")
	// }

	// cert := certificates.Data[0]
	// if cert.Attributes.CertificateContent == nil {
	// 	return fmt.Errorf("certificate content is nil")
	// }

	// certData, err := base64.StdEncoding.DecodeString(*cert.Attributes.CertificateContent)
	// if err != nil {
	// 	return fmt.Errorf("failed to decode certificate content: %v", err)
	// }

	// // 一時的な.cerファイルを作成
	// tempCertPath := fmt.Sprintf("/tmp/%s.cer", *cert.Attributes.SerialNumber)
	// if err := os.WriteFile(tempCertPath, certData, 0644); err != nil {
	// 	return fmt.Errorf("failed to write temporary certificate: %v", err)
	// }
	// defer os.Remove(tempCertPath)

	// // 証明書を保存するディレクトリを作成
	// mkdirCmd := "mkdir -p '/Users/admin/Library/MobileDevice/Certificates/'"
	// output, err := ExecuteSSHCommand(client, mkdirCmd, infoLogger)
	// if err != nil {
	// 	return fmt.Errorf("failed to create certificates directory: %v", err)
	// }
	// infoLogger.Printf("Successfully created certificates directory: %v", output)

	// // .cerから.p12に変換
	// err = ConvertCertToP12(
	// 	tempCertPath,
	// 	appStoreKeyPath,
	// 	p12Path,
	// 	"mementomori", // TODO: パスワードは設定可能にする
	// )
	// if err != nil {
	// 	return fmt.Errorf("failed to convert certificate to p12: %v", err)
	// }

	// .p12ファイルをbase64エンコード
	p12Data, err := os.ReadFile("/Users/masahiroaoki/Developer/open-ci/openci/apps/vm-runner/certificate.p12")
	if err != nil {
		return fmt.Errorf("failed to read p12 file: %v", err)
	}
	encodedP12 := base64.StdEncoding.EncodeToString(p12Data)

	// リモートマシンに.p12ファイルを保存
	saveCmd := fmt.Sprintf("echo '%s' | base64 -D > '%s'", encodedP12, p12Path)
	output, err := ExecuteSSHCommand(client, saveCmd, infoLogger)
	if err != nil {
		return fmt.Errorf("failed to save p12: %v", err)
	}
	infoLogger.Printf("Successfully saved p12: %v", output)

	return nil
}

func CreateCSR(commonName, country, state, locality, organization, orgUnit, email string) (string, error) {
	key, err := rsa.GenerateKey(rand.Reader, 2048)
	if nil != err {
		return "", fmt.Errorf("Failed to generate private key: %v", err)
	}

	subj := pkix.Name{
		CommonName:         commonName,
		Country:            []string{country},
		Province:           []string{state},
		Locality:           []string{locality},
		Organization:       []string{organization},
		OrganizationalUnit: []string{orgUnit},
	}

	template := x509.CertificateRequest{
		Subject:            subj,
		EmailAddresses:     []string{email},
		SignatureAlgorithm: x509.SHA256WithRSA,
	}
	csrBytes, err := x509.CreateCertificateRequest(rand.Reader, &template, key)
	if nil != err {
		return "", fmt.Errorf("Failed to create certificate request: %v", err)
	}

	csrPem := pem.EncodeToMemory(&pem.Block{Type: "CERTIFICATE REQUEST", Bytes: csrBytes})
	if nil == csrPem {
		return "", fmt.Errorf("Failed to PEM-encode CSR")
	}

	err = ioutil.WriteFile("developer_cert.key", pem.EncodeToMemory(&pem.Block{Type: "RSA PRIVATE KEY", Bytes: x509.MarshalPKCS1PrivateKey(key)}), 0600)
	if nil != err {
		return "", fmt.Errorf("Failed to save private key to file: %v", err)
	}

	encodedCSR := base64.StdEncoding.EncodeToString(csrPem)
	return encodedCSR, nil
}

func GenCertificate(ctx context.Context, client *asc.Client, certificateType string, base64CSR string) (string, error) {
	if certificateType == "" {
		return "", fmt.Errorf("certificate type must not be empty")
	}
	fmt.Printf("certificateType: %s\n", certificateType)

	if certificateType != "DEVELOPMENT" && certificateType != "DISTRIBUTION" {
		return "", fmt.Errorf("invalid certificate type: %s", certificateType)
	}
	fmt.Printf("base64CSR: %s\n", base64CSR)

	// base64デコード
	csrData, err := base64.StdEncoding.DecodeString(base64CSR)
	if err != nil {
		return "", fmt.Errorf("failed to decode base64 CSR: %v", err)
	}
	fmt.Printf("csrData: %s\n", csrData)

	// io.Readerとして渡すためにバッファを作成
	csrReader := bytes.NewReader(csrData)

	// 証明書の作成
	certResp, _, err := client.Provisioning.CreateCertificate(
		ctx,
		asc.CertificateType(certificateType),
		csrReader,
	)
	if err != nil {
		return "", fmt.Errorf("failed to create certificate: %v", err)
	}
	fmt.Printf("certResp: %+v\n", certResp)

	if certResp.Data.Attributes.CertificateContent == nil {
		return "", fmt.Errorf("certificate content is empty")
	}
	fmt.Printf("certResp.Data.Attributes.CertificateContent: %+v\n", certResp.Data.Attributes.CertificateContent)
	// 証明書コンテンツをデコード
	certData, err := base64.StdEncoding.DecodeString(*certResp.Data.Attributes.CertificateContent)
	if err != nil {
		return "", fmt.Errorf("failed to decode certificate content: %v", err)
	}

	// ファイルに保存
	err = os.WriteFile("developer_cert.cer", certData, 0644)
	if err != nil {
		return "", fmt.Errorf("failed to save certificate to file: %v", err)
	}

	return "developer_cert.cer", nil
}
