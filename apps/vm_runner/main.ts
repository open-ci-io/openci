// deno-lint-ignore-file no-explicit-any
import { Client } from "npm:ssh2";
import { Buffer } from "node:buffer";

import admin from "npm:firebase-admin";

import { v4 as uuidv4 } from "npm:uuid";
import {
  green,
  red,
  yellow,
} from "https://deno.land/std@0.224.0/fmt/colors.ts";
import { cleanUpVMs } from "./vm.ts";
import { delay } from "https://deno.land/std@0.224.0/async/delay.ts";

admin.initializeApp({
  credential: admin.credential.cert(
    JSON.parse(Deno.readTextFileSync("./service_account.json")),
  ),
});

let vmIp = "";

while (true) {
  const qs = await admin.firestore().collection("build_jobs").where(
    "buildStatus",
    "==",
    "queued",
  ).limit(1).get();

  if (qs.empty) {
    console.info("キューに入っているビルドジョブはありません");
    continue;
  }

  const job = qs.docs[0].data();
  const workflowId = job.workflowId;
  const workflowDocs = await admin.firestore().collection("workflows").doc(
    workflowId,
  ).get();
  const workflow = workflowDocs.data();
  if (!workflow) {
    console.error(`Workflow not found: ${workflowId}`);
    continue;
  }
  console.info(`Workflow: ${workflow.name}`);

  const installationToken = await getGithubAccessToken(
    job.github.installationId,
  );

  console.info(`Installation token: ${installationToken}`);

  const vmName = uuidv4();

  try {
    const command = new Deno.Command("tart", {
      args: ["clone", "sonoma", vmName],
    });
    await command.output();
  } catch (error) {
    console.error("コマンド実行エラー:", error);
  }

  try {
    const command = new Deno.Command("tart", { args: ["run", vmName] });
    command.output();
  } catch (error) {
    console.error("コマンド実行エラー:", error);
  }
  while (true) {
    const command = new Deno.Command("tart", { args: ["ip", vmName] });
    const output = await command.output();
    const result = new TextDecoder().decode(output.stdout);
    vmIp = result.trim();
    if (result.length > 0) {
      break;
    } else {
      console.info(yellow("Waiting for VM to start..."));
    }
  }
  console.info(green("VM ready"));

  const steps = workflow.steps;
  console.log("steps", steps);

  await executeCommands(vmIp, steps);
  await delay(30000);

  console.info(green("Commands executed"));

  await cleanUpVMs();
}

function executeCommands(
  vmIp: string,
  steps: any[],
): Promise<void> {
  return new Promise((resolve, reject) => {
    const conn = new Client();
    let buffer = "";

    conn.on("ready", () => {
      console.log("クライアント :: 準備完了");
      conn.shell((err: any, stream: any) => {
        if (err) {
          reject(err);
          return;
        }

        stream.on("close", () => {
          console.log("ストリーム :: クローズ");
          conn.end();
          resolve();
        }).on("data", (data: Buffer) => {
          buffer += data.toString();
          let newlineIndex;
          while ((newlineIndex = buffer.indexOf("\n")) !== -1) {
            const line = buffer.slice(0, newlineIndex).trim();
            if (line) {
              console.log("出力: " + line);
            }
            buffer = buffer.slice(newlineIndex + 1);
          }
        });

        let commandIndex = 0;
        const executeNextCommand = () => {
          if (commandIndex >= steps.length) {
            stream.write("exit\n");
            return;
          }

          const step = steps[commandIndex];
          const command = step.commands[0]; // 各ステップの最初のコマンドのみを実行
          const replacedCommand = command.includes("${githubAccessToken}")
            ? command.replace("${githubAccessToken}", "installationToken")
            : command;

          // コマンドを実行し、終了コードを取得
          stream.write(`${replacedCommand}; echo $?\n`);

          let commandOutput = "";
          const checkResult = (data: string) => {
            commandOutput += data;
            const lines = commandOutput.split("\n");
            if (lines.length >= 2) {
              const exitCode = parseInt(lines[lines.length - 2], 10);
              if (!isNaN(exitCode)) {
                if (exitCode === 0) {
                  console.log(green(`コマンド成功: ${replacedCommand}`));
                  commandIndex++;
                  executeNextCommand();
                } else {
                  console.error(
                    red(
                      `コマンド失敗: ${replacedCommand}, 終了コード: ${exitCode}`,
                    ),
                  );
                  stream.write("exit\n");
                }
                stream.removeListener("data", checkResult);
              }
            }
          };

          stream.on("data", checkResult);
        };

        executeNextCommand();
      });
    }).on("error", (err: any) => {
      reject(err);
    }).connect({
      host: vmIp,
      port: 22,
      username: "admin",
      password: "admin",
    });
  });
}

async function getGithubAccessToken(installationId: number): Promise<string> {
  const _baseUrl = "http://localhost:8080";

  const url = new URL("/installation_token", _baseUrl);
  const body = JSON.stringify({
    installationId: installationId,
  });

  const response = await fetch(url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: body,
  });

  if (!response.ok) {
    throw new Error(`APIエラー: ${await response.text()}`);
  }

  const responseBody = await response.json();
  return responseBody.installation_token.toString();
}
