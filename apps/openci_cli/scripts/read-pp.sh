#!/bin/bash

response=$(openci_cli2 read-provisioning-profile \
  --issuer-id=a6b7e4ee-e80b-41fb-8c5b-4f63234598eb \
  --key-id=TVVJSBM7TY \
  --path-to-private-key="/Users/masahiroaoki/Desktop/AuthKey_TVVJSBM7TY.p8" \
  --profile-id=RFG7XXZW2W)

exit_code=$?

# レスポンスをJSONフォーマットで出力
echo "{\"response\": \"$response\", \"exit_code\": $exit_code}"
