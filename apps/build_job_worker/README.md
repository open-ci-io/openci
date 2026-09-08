# build_job_worker

OpenCIのビルドjobを実行するDartバックエンドサービス。
jobを1件ずつ取得・実行する常駐プロセスです。

現在は設定の読み込み、jobを1件取得する関数、runの作成・完了記録、jobの完了記録、GitHub Checksの完了更新、OrchardのVM準備・削除・コマンド実行、Lokiへのログ送信、GitHubトークン・secretsの取得、ソースのcheckout・ワークフロー実行を実装しています。
`executeBuildJob()`で、取得済みのjobを実行開始の記録から結果保存・VM削除まで処理できます。
`runBuildJobWorker()`で、jobを1件ずつ取得して実行するループを利用できます。
`main.dart`からこのループを起動し、`executeBuildJob()`を呼び出します。
サーバー・Orchard・Lokiのクライアントは起動時に生成し、job間で共有します。
Composeでは`build-job-worker`を常駐サービスとして起動します。
現在のplannerは`needs`を扱わず、jobを`QUEUED`で作成します。

## 設定

- `OPENCI_SERVER_URL`: 必須。openci_serverの接続先。
- `INTERNAL_API_KEY`: 必須。内部APIの認証キー。
- `ORCHARD_SERVICE_ACCOUNT_NAME`: 必須。Orchardのサービスアカウント名。
- `ORCHARD_SERVICE_ACCOUNT_TOKEN`: 必須。Orchardの認証トークン。
- `BASE_VM_NAME`: 任意。ベースVM名。デフォルトは`base-macos`。
- `ORCHARD_API_URL`: 任意。デフォルトは`https://orchard-controller:6120`。
- `LOKI_URL`: 任意。workerからのログ送信先。デフォルトは`http://loki:3100`。
- `LOKI_URL_FOR_VM`: 任意。VMからのログ送信先。デフォルトは`http://192.168.64.1:3100`。
- `SENTRY_DSN`: 任意。設定するとworker内部の例外をSentryへ送信します。未設定・空文字列の場合は送信しません。

必須設定が未指定または空文字列の場合は、変数名を標準エラー出力へ出して
終了コード1で終了します。認証キーやトークンの値は出力しません。
`BUILD_JOB_ID`は不要です。Orchardの認証情報は環境変数から読み込みます。

`OrchardApiClient(config: config)`でクライアントを作成し、使用後に`close()`を呼び出します。
`waitForVmRunning()`は標準で3秒間隔・最大5分間、`running`または`active`になるまで待機します。
HTTP応答待ちも制限時間に含み、APIエラーは呼び出し元へ返します。
`prepareVm()`はVMを作成し、標準で最大15分の起動待ちを行ってVM情報を返します。
起動待ちが失敗した場合は作成済みVMの削除を試み、削除も失敗した場合は両方の原因を返します。
`execCommandWebSocket()`はVM内でコマンドを実行し、`onLog(line, stream)`にstdout・stderrを行単位で通知して終了コードを返します。
終了通知前の切断や不正なレスポンスはエラーにし、処理終了時に接続を閉じます。
VMのCPU数・メモリは`createLease()`の引数、`ORCHARD_VM_CPU`・`ORCHARD_VM_MEMORY_GB`、
デフォルト値（2コア・4 GiB）の順に決まります。
ローカルOrchardの`--no-pki`構成に対応します。
証明書の例外許可は設定した接続先のホスト・ポートに限定します。

`pushLogToLoki()`は、`lokiUrl: config.internalLokiUrl`を指定してログを1件ずつHTTP POSTします。
`run_id`・`build_job_id`などのラベルでログを識別します。
送信成功（HTTP 204）以外や通信エラーは呼び出し元へ返すため、ジョブ実行側でエラーを処理してください。
HTTPクライアントは呼び出し元で共有し、使用後に閉じます。

`executeCommand()`はWebSocketで受け取ったログを、stdout・stderrを区別して受信順にLokiへ送信します。
`lokiUrl: config.internalLokiUrl`とrun・job・必要に応じてstepのIDを指定します。
送信エラーは`onLogError`に通知し、後続ログの送信を続けます。このコールバックは例外を投げずにエラーを記録してください。
1件の送信待ちは標準で最大10秒（`logTimeout`）です。コマンド終了・実行エラーのどちらでも待機中のログを処理してから、終了コードまたは元の実行エラーを返します。
両クライアントの管理は呼び出し元で行います。

`writeFile()`はVM内の親ディレクトリを作成し、指定したパスへUTF-8の内容を書き込みます。
既存ファイルは上書きします。`mode: '+x'`で実行権限を付与し、`mode: '600'`なども指定できます。
書き込み・権限変更の終了コードが0以外ならエラーにします。
ファイル内容を含むコマンドや出力はログへ送らず、通信・実行例外にも内容を含めません。

`createBuildRun(api: api, jobId: job.id, runId: runId)`は、既存APIで実行開始を記録します。run IDは呼び出し元で生成します。
サーバー側でrunを`in_progress`として作成し、jobのrun数・最新run IDを更新します。
HTTP失敗（run ID重複の409を含む）や通信・変換エラーは`StateError`にし、レスポンス本文や元の例外メッセージは含めません。
自動再送は行いません。

`completeBuildRun(api: api, jobId: job.id, runId: runId, status: status)`は、既存APIでrunを`completed`に更新します。
`SUCCESS`・`FAILURE`・`CANCELLED`・`SKIPPED`・`TIMED_OUT`を、それぞれ小文字の`conclusion`として保存します。
`WAITING`・`QUEUED`・`IN_PROGRESS`は、APIを呼び出す前に`ArgumentError`にします。
HTTP失敗や通信・変換エラーは`StateError`にし、レスポンス本文や元の例外メッセージは含めません。
自動再送は行いません。job本体の更新は`completeBuildJob()`で行います。

`completeBuildJob(api: api, jobId: job.id, status: status, completedAt: completedAt)`は、既存APIでjobの終了状態と終了時刻を保存します。
`status`は`SUCCESS`などの大文字で送り、呼び出し元から受け取った`completedAt`はUTCのISO 8601形式に変換します。
受け付ける状態・APIエラーの扱いは`completeBuildRun()`と同じです。
自動再送は行いません。GitHub Checksの更新は`completeGitHubCheckRun()`で行います。

`completeGitHubCheckRun(api: api, jobId: job.id, status: status)`は、サーバー経由でjobに紐づくGitHub Checkを`completed`に更新します。
終了結果は`completeBuildRun()`と同じ小文字の`conclusion`で送り、GitHub Checkの終了時刻はサーバー側で設定します。
受け付ける状態・APIエラーの扱いは`completeBuildRun()`と同じです。自動再送は行いません。

`resolveGitHubInstallationToken(api: api, jobId: job.id)`は、既存の`OpenCiApiService`からjob用のGitHubトークンを取得して返します。
API失敗やトークンの欠落・空文字・型不正は`StateError`にし、レスポンス本文や元の例外メッセージは含めません。
返されたトークンを`checkoutRepository()`へ渡します。

`checkoutRepository()`は、引数で受け取ったGitHubトークンを使い、VMの`/tmp/workspace`へソースを取得します。
取得先はjobのコミットSHA、PRのhead ref、ブランチ（未指定なら`develop`）の順で決め、取得失敗はエラーにします。
`writeFile()`でスクリプトを配置し、`executeCommand()`で実行して`step_id: checkout`のログをLokiへ送ります。
トークンは取得時のHTTPヘッダーだけに設定し、remote URLには保存しません。スクリプトは権限`600`で配置し、実行終了時に削除します。
`workspacePath`で配置先を変更できます。

`fetchJobSecrets(api: api, jobId: job.id)`は、既存APIから`secretsContent`を取得して加工せず返します。
HTTP成功・`success: true`・`secretsContent`が文字列であることを確認し、空文字列もそのまま返します。
API失敗や不正な応答は`StateError`にし、レスポンス本文や元の例外メッセージは含めません。
返された文字列を`runWorkflow()`の`secretsContent`へ渡します。

`runWorkflow()`は、checkout済みのVMで`flutter pub get`と`flutter pub run genuine_ci/<workflowFileName>`を順に実行し、終了コードを返します。
`secretsContent`はAPIと同じ`NAME=value`形式で渡し、secretsがない場合は空文字列を渡します。
`.env`を権限`600`で上書きし、値をシェルコードとして評価せず環境変数に設定します。値の引用は不要です。
`vmHomePath`（標準`/Users/admin`）配下の`fvm/default`をFlutterに使い、run・job IDとVM用Loki URLを設定します。
`lokiUrl: config.internalLokiUrl`はworkerのログ送信先、`vmLokiUrl: config.lokiUrl`はVM内のワークフローの送信先です。
stdout・stderrは`step_id: run_workflow`でLokiへ送り、送信待ちが終わってから終了コードを返します。書き込み・Orchard通信の失敗は例外、Loki送信の失敗は`onLogError`へ通知します。
実行終了時に`.env`と実行スクリプトを削除します。

`executeBuildJob(api: api, orchardApi: orchardApi, lokiClient: lokiClient, config: config, job: job, onError: onError)`は、claim済みの`IN_PROGRESS`のjobを1件実行します。
run IDとVM名を生成し、run作成、GitHubトークン取得、VM準備、checkout、secrets取得、ワークフロー実行を順に行います。
VM準備は`prepare_vm`（表示名`Set up VM`）として、開始時に`IN_PROGRESS`、終了時に`SUCCESS`または`FAILURE`と処理時間をLokiへ送信します。既存のビルド画面で状態と所要時間を確認できます。
進捗イベントの送信は1件あたり最大10秒待ち、失敗してもjobの実行結果やVM削除の処理は変えません。
終了コード0なら`SUCCESS`、それ以外や実行途中の例外なら`FAILURE`として、run・job・GitHub Checksに結果の保存を試みます。
run作成が失敗した場合はrunの完了更新とVM作成を行わず、job・GitHub Checksの失敗記録を試みます。
VM準備に成功した場合は`finally`でVMの削除を試みます。起動待ち中の失敗は`prepareVm()`が削除を担当します。
結果保存とVM削除はそれぞれ失敗しても後続処理を続け、1処理の待ち時間は`finalizationTimeout`（標準10秒）で制限します。自動再送は行いません。
返り値は実行結果の`BuildJobStatus`です。結果保存やVM削除の失敗によって、この実行結果は変更しません。
コマンド出力の送信失敗は発生時に、進捗送信などそれ以外の例外は終了処理を試みた後に`onError`へ通知します。このコールバックは例外を投げずに記録してください。
クライアントの生成・共有・終了処理は呼び出し元で行います。キャンセル監視、job全体のタイムアウトはまだ行いません。

`runBuildJobWorker(api: api, executeJob: executeJob, shouldStop: shouldStop, onError: onError)`は、jobの取得と実行を順番に繰り返します。
`executeJob`には`executeBuildJob()`を呼ぶ関数を渡します。結果保存・VM削除を含む実行関数の終了を待ってから次のjobを取得するため、jobの同時実行は1件です。
jobがない場合と、取得・実行関数が例外を投げた場合は、`pollInterval`（標準3秒）だけ待って次のjobを取得します。
実行関数が`FAILURE`を返した場合もループを継続します。同じjobの自動再実行は行いません。
ループで捕捉した例外は`onError`へ通知します。`executeBuildJob()`内で捕捉する例外は、そちらへ渡した`onError`で記録してください。コールバックは例外を投げないようにしてください。
`shouldStop`が`true`なら新たなjob取得を止めます。取得待ち中に停止要求が来ても、取得できたjobは実行と後片付けを終えてから停止します。
待機中の停止要求は待機終了後に確認します。クライアントの生成・終了とOSの終了シグナルとの接続は`main.dart`で行います。

## 実行

### Composeから起動

ルートの`.env.example`を参考に、`.env`とserver用の認証ファイルを準備します。
Orchardのサービスアカウント名とAPI用トークンは`.env`へ設定してください。
Sentryへの通知を有効にする場合は、`.env`の`SENTRY_DSN_BUILD_JOB_WORKER`を設定します。
macOS側のOrchard workerとTartの`base-macos`も準備済みの状態で、リポジトリルートから実行します。
既存環境から切り替える場合は、更新前の構成でjobの取得を止め、実行中のjobが完了してからworkerを起動してください。

```sh
docker compose up -d --build build-job-worker
docker compose logs -f build-job-worker
```

workerの依存としてserver・DB・Orchard Controller・Lokiも起動します。
plannerも動かす場合は、`docker compose up -d --build build-job-planner`を実行します。

停止は`docker compose stop build-job-worker`で行います。
`BUILD_JOB_WORKER_STOP_GRACE_PERIOD`はjobの完了を待つ停止猶予時間で、標準1時間です。

### Dartから直接起動

リポジトリルートで`flutter pub get`を実行してから、このディレクトリで実行します。

```sh
OPENCI_SERVER_URL=http://localhost:8080 \
INTERNAL_API_KEY=local-development-key \
ORCHARD_API_URL=https://localhost:6120 \
ORCHARD_SERVICE_ACCOUNT_NAME=bootstrap-admin \
ORCHARD_SERVICE_ACCOUNT_TOKEN=local-development-token \
LOKI_URL=http://localhost:3100 \
dart run bin/main.dart
```

起動後はjobを継続して取得します。起動・取得・実行・結果保存・VM削除などの例外は標準エラー出力へ記録し、DSN設定時はSentryにも送信します。
Sentryへの送信はjobの処理を待たせずに行い、worker終了時に送信完了を最大5秒待ってからSentryを閉じます。送信の失敗でjobの結果は変更しません。
`SIGTERM`または`SIGINT`（Ctrl+C）で新しいjobの取得を止め、取得済みjobの結果保存・VM削除を試みてからクライアントを閉じます。
空キューの待機中なら最大3秒、job取得・実行中ならその処理が終わるまで待ちます。
停止シグナルによる正常終了は終了コード0、設定・起動に失敗した場合は終了コード1です。

## 検証

このディレクトリで実行します。WebSocketテストはローカルのテスト用サーバーを自動起動するため、OrchardやVMの起動は不要です。
ファイル書き込みテストはmacOSまたはLinuxの`/bin/sh`と`base64`を使い、一時ディレクトリ内で検証します。
checkoutテストはローカルの`git`も使い、一時リポジトリで取得結果を検証します。
ワークフローのテストは一時ディレクトリ内のテスト用Flutterコマンドで、環境変数・実行順・終了コードを検証します。
起動テストは子プロセスとローカルの偽APIで、認証・ログ送信・結果保存・停止時の後片付けを検証します。停止シグナルのテストはmacOS・Linux向けです。

```sh
dart format --output=none --set-exit-if-changed .
dart analyze --fatal-infos
dart test
dart test integration_test
```

DockerイメージはDart 3.12.2でコンパイルし、非rootユーザーで実行します。リポジトリルートで次の検証を行えます。

```sh
docker compose --env-file .env.example --profile '*' config --quiet
docker build -f apps/build_job_worker/Dockerfile -t openci-build-job-worker .
```

## 残タスク

- 実行中jobのキャンセル監視。
- VM準備に失敗した場合の自動リトライ。
- checkout・ワークフロー全体の進捗イベント送信。
