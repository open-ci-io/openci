import { delay } from "https://deno.land/std@0.224.0/async/delay.ts";
import { green, yellow } from "https://deno.land/std@0.224.0/fmt/colors.ts";
import * as Sentry from "npm:@sentry/deno";
import { cert, initializeApp } from "npm:firebase-admin/app";
import { getFirestore } from "npm:firebase-admin/firestore";
import { v4 as uuidv4 } from "npm:uuid";
import { baseUrl } from "./base_url.ts";
import {
  getBuildJob,
  getWorkflowDocs,
  setStatusToInProgress,
} from "./build_job.ts";
import { getGithubAccessToken } from "./github.ts";
import { cleanUpVMs, cloneVM, executeCommands, runVM, stopVM } from "./vm.ts";

initializeApp({
  credential: cert(
    JSON.parse(Deno.readTextFileSync("./service_account.json")),
  ),
});

Sentry.init({
  dsn:
    "https://5eafbb12527af61e3e9ad00c76a84485@o4507005123166208.ingest.us.sentry.io/4508194852765696",
});

export const db = getFirestore();

let vmIp = "";

while (true) {
  const vmName = uuidv4();

  try {
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
  } catch (error) {
    console.error(`Error occurred during job execution: ${error}`);
    Sentry.captureException(error);

    if (vmName) {
      try {
        await stopVM(vmName);
        await cleanUpVMs();
      } catch (cleanupError) {
        console.error(`Failed to cleanup VM: ${cleanupError}`);
        Sentry.captureException(cleanupError);
      }
    }
    await delay(5000);
  }
}
