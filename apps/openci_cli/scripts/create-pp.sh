#!/bin/bash
# create-certificate.sh

# Create provisioning profile
response=$(dart run openci_cli2 create-provisioning-profile \
  --issuer-id=a6b7e4ee-e80b-41fb-8c5b-4f63234598eb \
  --key-id=TVVJSBM7TY \
  --path-to-private-key="/Users/masahiroaoki/Desktop/AuthKey_TVVJSBM7TY.p8" \
  --certificate-id=HD4DAU37CS \
  --profile-name="OpenCI PP" \
  --profile-type="IOS_APP_STORE" \
  --bundle-id="DM9VQG9XH9")

json=$(echo "$response" | jq .)
echo "$json"
