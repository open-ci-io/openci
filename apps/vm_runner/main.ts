import { Client } from "npm:ssh2";
import { Buffer } from "node:buffer";


const config = {
  host: "192.168.64.2",
  port: 22,
  username: "admin",
  password: "admin",
};

const conn = new Client();

conn.on("ready", () => {
  console.log("SSH接続が確立されました");

  conn.shell((err: Error | undefined, stream: any) => {
    if (err) throw err;
    stream.on("close", () => {
      console.log("シェルセッションが閉じられました");
      conn.end();
    }).on("data", (data: Buffer) => {
      console.log("出力:", data.toString());
    }).stderr.on("data", (data: Buffer) => {
      console.log("STDERRの出力:", data.toString());
    });

    // コマンドを順番に実行
    stream.write("ls\n");
    stream.write("cd flutter\n");
    stream.write("pwd\n"); // 現在のディレクトリを確認
    stream.write("exit\n"); // シェルセッションを終了
  });
});

conn.on("error", (err: any) => {
  console.error("SSH接続エラー:", err);
});

conn.connect(config);
