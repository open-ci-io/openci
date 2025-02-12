#!/bin/bash
# create-certificate.sh

response=$(openci_cli2 create-certificate \
  --issuer-id=a6b7e4ee-e80b-41fb-8c5b-4f63234598eb \
  --key-id=TVVJSBM7TY \
  --path-to-private-key="/Users/masahiroaoki/Desktop/AuthKey_TVVJSBM7TY.p8" \
  --certificate-type=DISTRIBUTION)

json=$(echo "$response" | jq .)
echo "$json"
