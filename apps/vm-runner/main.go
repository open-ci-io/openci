package main

import (
	"context"
	"os"

	"github.com/urfave/cli/v3"
)

func main() {
	infoLogger, errorLogger := InitializeLoggers()

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
			return RunApp(ctx, cmd, infoLogger, errorLogger)
		},
	}).Run(context.Background(), os.Args)
}
