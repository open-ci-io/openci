// deno-lint-ignore-file no-explicit-any
import { v4 as uuidv4 } from "npm:uuid";
import { green, yellow } from "https://deno.land/std@0.224.0/fmt/colors.ts";
import {
  cleanUpVMs,
  cloneVM,
  executeCommands,
  runVM,
  setStatusToInProgress,
  stopVM,
} from "./vm.ts";
import { delay } from "https://deno.land/std@0.224.0/async/delay.ts";
import { getBuildJob, getWorkflowDocs } from "./build_job.ts";
import { cert, initializeApp } from "npm:firebase-admin/app";
import { getFirestore } from "npm:firebase-admin/firestore";
import { getGithubAccessToken } from "./github.ts";
import { baseUrl } from "./base_url.ts";

initializeApp({
  credential: cert(
    JSON.parse(Deno.readTextFileSync("./service_account.json")),
  ),
});

export const db = getFirestore();

let vmIp = "";

while (true) {
  const qs = await getBuildJob(db);
  if (qs.empty) {
    console.info(
      `[${new Date().toISOString()}] No queued build jobs found`,
    );
    await delay(1000);
    continue;
  }

  const job = qs.docs[0].data();
  const jobId = job.id;

  await setStatusToInProgress(jobId);

  const workflowId = job.workflowId;
  const workflowDocs = await getWorkflowDocs(db, workflowId);
  const workflow = workflowDocs.data();
  if (!workflow) {
    console.error(`Workflow not found: ${workflowId}`);
    continue;
  }
  console.info(`Workflow: ${workflow.name}`);

  const installationToken = await getGithubAccessToken(
    job.github.installationId,
    baseUrl,
  );
  console.info(`Installation token: ${installationToken}`);

  const vmName = uuidv4();

  await cloneVM(vmName);
  runVM(vmName);

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

  await executeCommands(vmIp, steps, jobId);

  console.info(green("Commands executed"));
  await stopVM(vmName);
  await cleanUpVMs();
}
