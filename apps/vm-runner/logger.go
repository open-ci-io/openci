package main

import (
	"log"
	"os"

	"github.com/fatih/color"
)

func InitializeLoggers() (*log.Logger, *log.Logger) {
	infoLogger := log.New(os.Stdout, color.GreenString("[INFO] "), log.LstdFlags|log.Lshortfile)
	errorLogger := log.New(os.Stderr, color.RedString("[ERROR] "), log.LstdFlags|log.Lshortfile)
	return infoLogger, errorLogger
}
