package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"time"

	"github.com/golang-jwt/jwt"
)

func GetGitHubInstallationToken(pemPath string, installationID int64, appID int64) (string, error) {
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
