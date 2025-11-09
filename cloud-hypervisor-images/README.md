# Cloud Hypervisor - Ubuntu VM Setup

Cloud HypervisorでUbuntuを起動するための完全なセットアップガイドです。
Hetzner dedicated machineなどのベアメタルサーバーで使用できます。

## 概要

Cloud Hypervisorは、Rustで書かれた軽量なVMM（Virtual Machine Monitor）で、100-150msの高速起動が可能です。KVMの上で動作し、FirecrackerやcrosvmとRust VMMクレートを共有しています。

### 特徴

- **高速起動**: 100-150msで起動
- **軽量**: 最小限のメモリフットプリント
- **セキュア**: Rustで実装
- **KVMベース**: Linuxカーネルのハードウェア仮想化を利用

## ファイル構成

```
cloud-hypervisor-images/
├── README.md                  # このファイル
├── install.sh                 # Cloud Hypervisorのインストール
├── build-ubuntu.sh            # Ubuntuイメージのビルド
├── start-vm.sh                # VM起動スクリプト
├── config/                    # 設定ファイル
└── scripts/                   # 追加スクリプト
```

## 必要な環境

- **OS**: Ubuntu 20.04/22.04/24.04 または Debian
- **CPU**: Intel VT-x または AMD-V サポート
- **カーネル**: 4.11以上（推奨: 5.6以上）
- **権限**: root権限（インストール時）

## セットアップ手順

### 1. Cloud Hypervisorのインストール

```bash
cd cloud-hypervisor-images
sudo ./install.sh
```

このスクリプトは以下を実行します：
- 必要な依存関係のインストール（libguestfs-tools、qemu-utilsなど）
- KVMモジュールの有効化
- Cloud Hypervisor v44.0のダウンロードとインストール
- ファームウェア（rust-hypervisor-firmware）のダウンロード
- ネットワークブリッジ（virbr0）の作成
- systemdサービステンプレートの作成

### 2. Ubuntuイメージのビルド

```bash
./build-ubuntu.sh
```

このスクリプトは以下を実行します：
- Ubuntu 22.04 Cloud Imageのダウンロード
- イメージのリサイズ（20GB）
- 必要なパッケージのインストール
- RAW形式への変換
- cloud-init設定の生成

**出力ファイル:**
- `ubuntu-cloudhypervisor.raw` - ルートファイルシステム
- `cloud-init.img` - 初期設定用cloud-initイメージ

**デフォルト認証情報:**
- ユーザー名: `ubuntu`
- パスワード: `ubuntu123`

### 3. VMの起動

#### 対話モードで起動

```bash
sudo ./start-vm.sh
```

#### バックグラウンドで起動

```bash
CH_BACKGROUND=1 sudo ./start-vm.sh
```

#### カスタム設定で起動

```bash
CH_CPUS=8 CH_MEMORY=4096M sudo ./start-vm.sh my-vm
```

## 使用例

### 基本的な使用

```bash
# 1. インストール
sudo ./install.sh

# 2. イメージビルド
./build-ubuntu.sh

# 3. VM起動
sudo ./start-vm.sh
```

### 複数VMの起動

```bash
# VM 1
CH_CPUS=4 CH_MEMORY=2048M CH_BACKGROUND=1 sudo ./start-vm.sh vm1

# VM 2
CH_CPUS=4 CH_MEMORY=2048M CH_BACKGROUND=1 sudo ./start-vm.sh vm2

# ログ確認
tail -f /tmp/vm1-serial.log
```

### カスタムイメージの使用

```bash
./start-vm.sh my-vm /path/to/custom.raw /path/to/cloud-init.img
```

## 環境変数

| 変数 | 説明 | デフォルト |
|------|------|-----------|
| `CH_CPUS` | CPU数 | 4 |
| `CH_MEMORY` | メモリサイズ | 2048M |
| `CH_BACKGROUND` | バックグラウンド起動 | 0 |

## VMの管理

### VMの停止

```bash
# PIDを確認
ps aux | grep cloud-hypervisor

# プロセスを停止
kill <PID>
```

### シリアル出力の確認

```bash
tail -f /tmp/ubuntu-vm-serial.log
```

### API経由での管理

```bash
# API socketを使用
curl --unix-socket /tmp/cloud-hypervisor-ubuntu-vm.sock \
  http://localhost/api/v1/vm.info
```

## ネットワーク設定

### ブリッジネットワーク

デフォルトでは`virbr0`ブリッジ（192.168.100.1/24）が作成されます。

```bash
# ブリッジ確認
ip addr show virbr0

# ルーティング設定
sudo iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -j MASQUERADE
```

### VMへのSSHアクセス

```bash
# VM内でIPアドレスを確認（シリアルコンソール経由）
ip addr show

# ホストからSSH
ssh ubuntu@<VM_IP>
```

## トラブルシューティング

### KVMが利用できない

```bash
# 仮想化サポートの確認
grep -E 'vmx|svm' /proc/cpuinfo

# KVMモジュールのロード
sudo modprobe kvm_intel  # Intel
# または
sudo modprobe kvm_amd    # AMD

# /dev/kvmの確認
ls -l /dev/kvm
```

### ネットワークに接続できない

```bash
# ブリッジの再作成
sudo ip link del virbr0
sudo ip link add virbr0 type bridge
sudo ip addr add 192.168.100.1/24 dev virbr0
sudo ip link set virbr0 up

# IP転送の有効化
sudo sysctl -w net.ipv4.ip_forward=1
```

### イメージビルドが失敗する

```bash
# libguestfs環境変数の設定
export LIBGUESTFS_BACKEND=direct

# キャッシュのクリア
sudo rm -rf /var/tmp/.guestfs-*
```

## パフォーマンス比較

| VMM | 起動時間 | 特徴 |
|-----|---------|------|
| Cloud Hypervisor | 100-150ms | KVMベース、UEFI対応 |
| Firecracker | 100-200ms | AWS Lambda使用 |
| crosvm | ~150ms | ChromeOSで使用 |
| QEMU/KVM | 数秒 | 完全な仮想化機能 |
| LXD | <1秒 | コンテナ（要ネットワーク最適化） |

## 高度な使用

### カスタムカーネルでのブート

```bash
# vmlinuxカーネルを使用
cloud-hypervisor \
  --kernel /path/to/vmlinux \
  --disk path=ubuntu.raw \
  --cmdline "console=ttyS0 root=/dev/vda1" \
  --cpus boot=4 \
  --memory size=2048M
```

### ホットプラグ

```bash
# CPU追加（API経由）
curl --unix-socket /tmp/cloud-hypervisor-vm.sock \
  -X PUT http://localhost/api/v1/vm.resize \
  -H "Content-Type: application/json" \
  -d '{"desired_vcpus": 8}'
```

## 参考資料

- [Cloud Hypervisor 公式サイト](https://www.cloudhypervisor.org/)
- [GitHub リポジトリ](https://github.com/cloud-hypervisor/cloud-hypervisor)
- [Cloud Hypervisor ドキュメント](https://www.cloudhypervisor.org/docs/)
- [Rust VMM プロジェクト](https://github.com/rust-vmm)

## ライセンス

このプロジェクトのスクリプトはMITライセンスです。
Cloud Hypervisor自体はApache License 2.0 / MIT Licenseです。

## サポート

問題が発生した場合：

1. ログを確認: `/tmp/*-serial.log`
2. Cloud Hypervisorのバージョン確認: `cloud-hypervisor --version`
3. KVMの状態確認: `lsmod | grep kvm`
4. システムログ: `journalctl -xe`

---

**作成日**: 2025-11-09
**Cloud Hypervisor バージョン**: v44.0
**対象OS**: Ubuntu 22.04 (Jammy)
