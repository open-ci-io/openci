# GenuineCI server

リポジトリルートで次を実行すると、サーバーとAPIクライアントのコードを生成できます。

```sh
flutter pub get --enforce-lockfile
dart pub global activate serverpod_cli 4.0.0-rc.2
serverpod generate --directory apps/genuineci_server
```

生成先は `apps/genuineci_server/lib/src/generated` と
`packages/genuineci_api_client/lib/src/protocol` です。
生成ファイルは直接編集せず、サーバー側のAPI・モデル定義から再生成します。

`serverpod generate` に `--force` を付けると、更新判定にかかわらず再生成できます。
CIではこの方法で生成し直し、差分が出ないことを確認します。
