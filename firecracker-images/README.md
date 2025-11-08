# Firecracker Ubuntu Rootfs Image Builder

GitHub Actions Self-hosted RunnerとRubyを含むFirecracker用のカスタムUbuntu rootfsイメージを作成するツールです。

## 概要

このツールは**virt-customize**を使用して、Ubuntu Cloud Imageをベースに以下を含むFirecracker用のrootfsイメージを作成します：

- Ubuntu 22.04 (Jammy) Cloud Image
- Ruby (最新版)
- GitHub Actions Runner v2.321.0
- systemd
- 必要な開発ツール (git, curl, tmux, etc.)

## 方式の特徴

### virt-customizeを使用する理由

- ✅ **シンプル**: mount/umount/chroot不要
- ✅ **堅牢**: エラーハンドリングが自動
- ✅ **高速**: 公式イメージベースで素早くビルド
- ✅ **安全**: 公式Ubuntu Cloud Imageを使用

## 前提条件

### Linux環境（Ubuntu/Debian）

```bash
sudo apt-get update
sudo apt-get install -y libguestfs-tools qemu-utils wget
```

### その他のLinux（RHEL/CentOS/Fedora）

```bash
sudo yum install -y libguestfs-tools qemu-img wget
# または
sudo dnf install -y libguestfs-tools qemu-img wget
```

## ディレクトリ構造

```
firecracker-images/
├── build.sh                    # メインビルドスクリプト（virt-customize版）
├── config/
│   └── runner.service         # GitHub Actions Runner systemdサービス
└── README.md                  # このファイル
```

## ビルド方法

### 1. ビルドスクリプトを実行

```bash
cd firecracker-images
chmod +x build.sh
./build.sh
```

**注意**: virt-customize方式では**sudoは不要**です（内部で必要に応じて権限昇格します）

ビルドプロセスは以下を実行します：

1. Ubuntu Cloud Image (qcow2) をダウンロード
2. イメージを10GBにリサイズ
3. virt-customizeでカスタマイズ：
   - パッケージを更新
   - Ruby、git、tmux等をインストール
   - GitHub Actions Runnerをダウンロード・セットアップ
   - systemdサービスを設定
   - 不要なファイルをクリーンアップ
4. qcow2からEXT4 raw形式に変換
5. 一時ファイルをクリーンアップ

### 2. 完成

ビルドが成功すると、`ubuntu-runner.ext4` ファイルが生成されます。

## イメージのカスタマイズ

### Ubuntuバージョンを変更

`build.sh`の`UBUNTU_VERSION`と`CLOUD_IMAGE_URL`を編集：

```bash
# Ubuntu 20.04を使用する場合
UBUNTU_VERSION="focal"
CLOUD_IMAGE_URL="https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
```

### イメージサイズを変更

`build.sh`の`IMAGE_SIZE`変数を編集：

```bash
IMAGE_SIZE="10G"  # 10GBに設定
# IMAGE_SIZE="20G"  # 20GBに変更可能
```

### 追加パッケージをインストール

`build.sh`の`virt-customize`コマンド内の`--install`オプションに追加：

```bash
virt-customize -a "$TEMP_IMAGE" \
    --update \
    --install ruby-full,git,curl,wget,tmux,jq,sudo,openssh-server,your-package-here \
    ...
```

### GitHub Actions Runnerのバージョンを変更

`build.sh`内の2箇所で`RUNNER_VERSION`を変更：

```bash
RUNNER_VERSION="2.321.0"  # 最新版に更新
```

## Firecrackerでの使用方法

### 1. Firecrackerカーネルを取得

```bash
# Firecracker公式リリースからカーネルをダウンロード
curl -fsSL -o vmlinux.bin https://s3.amazonaws.com/spec.ccfc.min/img/quickstart_guide/x86_64/kernels/vmlinux.bin
```

### 2. Firecracker設定ファイルを作成

`vm-config.json`:

```json
{
  "boot-source": {
    "kernel_image_path": "vmlinux.bin",
    "boot_args": "console=ttyS0 reboot=k panic=1 pci=off root=/dev/vda rw"
  },
  "drives": [
    {
      "drive_id": "rootfs",
      "path_on_host": "ubuntu-runner.ext4",
      "is_root_device": true,
      "is_read_only": false
    }
  ],
  "machine-config": {
    "vcpu_count": 2,
    "mem_size_mib": 2048
  },
  "network-interfaces": [
    {
      "iface_id": "eth0",
      "guest_mac": "AA:FC:00:00:00:01",
      "host_dev_name": "tap0"
    }
  ]
}
```

### 3. Firecrackerを起動

```bash
# Firecrackerソケットを作成
rm -f /tmp/firecracker.socket

# Firecrackerを起動
firecracker --api-sock /tmp/firecracker.socket --config-file vm-config.json
```

### 4. JIT Configを渡す

VM起動後、JIT Configを渡す方法：

#### オプション1: cloud-initを使用（推奨）

cloud-init用のメタデータを作成してVMに渡します。

#### オプション2: シリアルコンソール経由

```bash
# JIT Configをファイルに書き込む（VM内で実行）
echo "YOUR_JIT_CONFIG_HERE" > /etc/runner-jitconfig
```

するとsystemdサービスが自動的にRunnerを起動します。

## トラブルシューティング

### virt-customizeが見つからない

```bash
sudo apt-get install libguestfs-tools
```

### "supermin: failed to find a suitable kernel" エラー

```bash
# Ubuntuの場合
sudo apt-get install linux-image-generic

# カーネルモジュールを再構築
sudo update-guestfs-appliance
```

### ダウンロードが遅い

日本のミラーを使用する場合、`CLOUD_IMAGE_URL`を変更：

```bash
CLOUD_IMAGE_URL="http://jp.archive.ubuntu.com/ubuntu-cloud-images/jammy/current/jammy-server-cloudimg-amd64.img"
```

### ビルドが途中で失敗する

ログを確認し、エラーメッセージに従って対処してください。
よくある原因：
- ディスク容量不足
- ネットワーク接続の問題
- libguestfsのバージョンが古い

## openci-runnerとの統合

このイメージはopenci-runnerプロジェクトと統合して使用できます。

`openci-runner/src/index.ts`のコメント部分（70-78行目）を実装し、
JIT Configを生成してFirecracker VMに渡すことで、
GitHub Actions Self-hosted Runnerとして動作します。

### 統合の流れ

```
1. GitHub Webhook受信（openci-runner）
2. JIT Config生成（openci-runner）
3. Firecracker VM起動（Hetzner Dedicated Server）
4. JIT Configを渡す
5. Runner起動、ジョブ実行
6. 完了後VM削除
```

## セキュリティに関する注意

- デフォルトのrootパスワードは `firecracker` です。本番環境では必ず変更してください。
- SSH鍵認証を設定することを強く推奨します。
- ファイアウォール設定を適切に行ってください。
- 使い捨てVMとして運用することを推奨します。

## パフォーマンス

virt-customize方式の利点：

| 項目 | debootstrap方式 | virt-customize方式 |
|---|---|---|
| ビルド時間 | 15-30分 | 5-10分 |
| コード行数 | ~200行 | ~100行 |
| エラー率 | 中 | 低 |
| メンテナンス性 | 中 | 高 |

## ライセンス

このプロジェクトはopenciプロジェクトの一部です。

## 参考資料

- [Firecracker Getting Started](https://github.com/firecracker-microvm/firecracker/blob/main/docs/getting-started.md)
- [Ubuntu Cloud Images](https://cloud-images.ubuntu.com/)
- [libguestfs virt-customize](http://libguestfs.org/virt-customize.1.html)
- [GitHub Actions Self-hosted Runners](https://docs.github.com/en/actions/hosting-your-own-runners)
