// deno-lint-ignore-file no-explicit-any
import {
  green,
  red,
  yellow,
} from "https://deno.land/std@0.224.0/fmt/colors.ts";
import { Buffer } from "node:buffer";
import { Client } from "npm:ssh2";
import { setStatusToFailure, setStatusToSuccess } from "./build_job.ts";
import { Firestore } from "npm:firebase-admin/firestore";

export async function cleanUpVMs() {
  while (true) {
    const command = new Deno.Command("tart", { args: ["list"] });
    const output = await command.output();
    const result = new TextDecoder().decode(output.stdout);

    const lines = result.split("\n").slice(1); // ヘッダー行をスキップ
    for (const line of lines) {
      const parts = line.trim().split(/\s+/);
      if (parts.length >= 2) {
        const deletingVmName = parts[1];
        if (deletingVmName !== "sonoma") {
          console.log(`VMを削除中: ${deletingVmName}`);
          const deleteCommand = new Deno.Command("tart", {
            args: ["delete", deletingVmName],
          });
          try {
            await deleteCommand.output();
            console.log(green(`${deletingVmName} を削除しました`));
          } catch (error) {
            console.error(
              yellow(
                `${deletingVmName} の削除中にエラーが発生しました: ${error}`,
              ),
            );
          }
        }
      }
    }

    console.log(green("全てのVMの削除が完了しました"));
    break;
  }
}

export async function cloneVM(vmName: string): Promise<void> {
  const baseVMName = "sonoma";
  try {
    const command = new Deno.Command("tart", {
      args: ["clone", baseVMName, vmName],
    });
    await command.output();
  } catch (error) {
    console.error("Command execution error:", error);
  }
}

export function runVM(vmName: string): void {
  try {
    const command = new Deno.Command("tart", { args: ["run", vmName] });
    command.output();
  } catch (error) {
    console.error("Command execution error:", error);
  }
}

export async function stopVM(vmName: string): Promise<void> {
  try {
    const command = new Deno.Command("tart", { args: ["stop", vmName] });
    await command.output();
  } catch (error) {
    console.error("Command execution error:", error);
  }
}

export function executeCommands(
  db: Firestore,
  vmIp: string,
  steps: any[],
  jobId: string,
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
          console.log("Stream :: close");
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

        let commandIndex = 0;
        const executeNextCommand = async () => {
          if (commandIndex >= steps.length) {
            stream.write("exit\n");
            await setStatusToSuccess(db, jobId);
            return;
          }

          const step = steps[commandIndex];
          const command = step.commands[0];
          const replacedCommand = command.includes("${githubAccessToken}")
            ? command.replace(
              "${githubAccessToken}",
              "installationToken",
            )
            : command;

          stream.write(`${replacedCommand}; echo $?\n`);

          let commandOutput = "";
          const checkResult = async (data: string) => {
            commandOutput += data;
            const lines = commandOutput.split("\n");
            if (lines.length >= 2) {
              const exitCode = parseInt(
                lines[lines.length - 2],
                10,
              );
              if (!isNaN(exitCode)) {
                if (exitCode === 0) {
                  console.log(
                    green(
                      `Command succeeded: ${replacedCommand}`,
                    ),
                  );
                  commandIndex++;
                  executeNextCommand();
                } else {
                  console.error(
                    red(
                      `Command failed: ${replacedCommand}, exit code: ${exitCode}`,
                    ),
                  );
                  await setStatusToFailure(db, jobId);
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
