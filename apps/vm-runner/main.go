package main

import (
	"context"
	"encoding/base64"
	"fmt"
	"os"
	"time"

	"github.com/cidertool/asc-go/asc"
	"github.com/urfave/cli/v3"
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

	appStoreClient, err := initAppStoreClient(cmd)
	if err != nil {
		return err
	}

	_, err = getProvisioningProfiles(ctx, appStoreClient, "io.open-ci.app.dashboard")
	if err != nil {
		return err
	}

	// err = getCertificateContent(ctx, appStoreClient)
	// if err != nil {
	// 	return err
	// }

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

func getProvisioningProfiles(ctx context.Context, appStoreClient *asc.Client, bundleID string) (*asc.ProfilesResponse, error) {
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
