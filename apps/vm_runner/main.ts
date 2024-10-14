// deno-lint-ignore-file no-explicit-any
import { Client } from "npm:ssh2";
import { Buffer } from "node:buffer";

import admin from "npm:firebase-admin";

import { v4 as uuidv4 } from "npm:uuid";
import { green, yellow } from "https://deno.land/std@0.224.0/fmt/colors.ts";
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
      console.log("Client :: ready");
      conn.shell((err: any, stream: any) => {
        if (err) {
          reject(err);
          return;
        }

        stream.on("close", () => {
          console.log("Stream :: closed");
          conn.end();
          resolve();
        }).on("data", (data: Buffer) => {
          buffer += data.toString();
          let newlineIndex;
          while ((newlineIndex = buffer.indexOf("\n")) !== -1) {
            const line = buffer.slice(0, newlineIndex).trim();
            if (line) {
              console.log("Output: " + line);
            }
            buffer = buffer.slice(newlineIndex + 1);
          }
        });

        for (const step of steps) {
          for (const command of step.commands) {
            if (command.includes("${githubAccessToken}")) {
              const replacedCommand = command.replace(
                "${githubAccessToken}",
                "installationToken",
              );
              stream.write(replacedCommand + "\n");
            } else {
              stream.write(command + "\n");
            }
          }
        }

        stream.write("exit\n"); // セッションを終了
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
