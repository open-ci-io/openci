#!/bin/bash

response=$(dart run openci_cli2 list-bundle-ids \
  --issuer-id=a6b7e4ee-e80b-41fb-8c5b-4f63234598eb \
  --key-id=TVVJSBM7TY \
  --path-to-private-key="/Users/masahiroaoki/Desktop/AuthKey_TVVJSBM7TY.p8" \
  --filter-identifier="io.openci.dashboard.ios")

# レスポンスをJSONフォーマットで出力
echo "$response"