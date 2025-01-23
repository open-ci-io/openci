#!/bin/bash

set -e

P12_PATH="/Users/masahiroaoki/Developer/open-ci/openci/apps/vm-runner/output.p12"
if [ -z "$P12_PATH" ]; then
  echo "Error: P12 path is required"
  exit 1
fi

KEYCHAIN_PATH="$HOME/Library/Keychains/app-signing.keychain-db"
KEYCHAIN_PASSWORD="mementomori"
P12_PASSWORD="12345678"

# # キーチェーンの作成（存在しない場合）
security create-keychain -p "$KEYCHAIN_PASSWORD" "$KEYCHAIN_PATH" || true

# # キーチェーン設定
security set-keychain-settings -lut 21600 "$KEYCHAIN_PATH"
echo "Keychain settings set successfully"

# キーチェーンのロック解除
security unlock-keychain -p "$KEYCHAIN_PATH"
echo "Keychain unlocked successfully"

# 証明書のファイル存在確認
if [ ! -f "$P12_PATH" ]; then
  echo "Error: P12 file not found at path: $P12_PATH"
  exit 1
fi
echo "P12 file exists at: $P12_PATH"

# ファイルのパーミッション変更
chmod 644 "$P12_PATH"

# 証明書のインポート
security import "$P12_PATH" \
  -P "$P12_PASSWORD" \
  -A \
  -t cert \
  -f pkcs12 \
  -k "$KEYCHAIN_PATH"
echo "Certificate imported successfully"

# キーチェーンをデフォルトリストに追加
security list-keychain -d user -s "$KEYCHAIN_PATH" $(security list-keychains -d user | tr -d '"')
echo "Keychain list set successfully"

# パーティションリストの設定
security set-key-partition-list \
  -S "apple-tool:,apple:" \
  -s \
  -k "$KEYCHAIN_PASSWORD" \
  "$KEYCHAIN_PATH"
echo "Partition list set successfully" 