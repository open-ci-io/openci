import { red } from "https://deno.land/std@0.224.0/fmt/colors.ts";
import {
    FieldValue,
    type Firestore,
    Timestamp,
} from "npm:firebase-admin/firestore";
import { NodeSSH } from "npm:node-ssh";

export async function executeSteps(
    db: Firestore,
    steps: any[],
    ssh: NodeSSH,
) {
    const logId = db.collection("logs").doc().id;
    for (const step of steps) {
        for (const command of step.commands) {
            await executeCommand(db, command, logId, ssh);
        }
    }
}

async function executeCommand(
    db: Firestore,
    command: string,
    logId: string,
    ssh: NodeSSH,
) {
    const data: { timestamp: Timestamp; log: string }[] = [];
    let result = "success";
    const defaultCommand = `source ~/.zshrc`;
    const commandToExecute = `${defaultCommand} && ${command}`;
    console.log(`Executing command: ${commandToExecute}`);
    await ssh.execCommand(commandToExecute, {
        onStdout(chunk) {
            const timestamp = Timestamp.now();
            data.push({
                timestamp,
                log: chunk.toString("utf8"),
            });
            console.log(
                `[${timestamp.toDate()}]${chunk.toString("utf8")}`,
            );
        },
        onStderr(chunk) {
            result = "failure";
            const timestamp = Timestamp.now();
            data.push({
                timestamp,
                log: chunk.toString("utf8"),
            });
            console.log(
                `[${timestamp.toDate()}]${red(chunk.toString("utf8"))}`,
            );
        },
    });

    const body = {
        "command": command,
        logs: data,
    };

    await db.collection("logs").doc(logId).set({
        logs: FieldValue.arrayUnion(...[body]),
        "buildStatus": result,
    }, { merge: true });
}
