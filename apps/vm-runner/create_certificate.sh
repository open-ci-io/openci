#!/bin/bash

# Define certificate files
CERT_FILE="developer_cert.cer"
KEY_FILE="developer_cert.key"
P12_FILE="certificate.p12"
CERT_NAME="Certificate Name"

# Check if required files exist
if [ ! -f "$CERT_FILE" ] || [ ! -f "$KEY_FILE" ]; then
    echo "Error: $CERT_FILE or $KEY_FILE not found"
    exit 1
fi

# Create p12 file
openssl pkcs12 -export \
    -in "$CERT_FILE" \
    -inkey "$KEY_FILE" \
    -out "$P12_FILE" \
    -name "$CERT_NAME"

echo "Successfully created $P12_FILE"
