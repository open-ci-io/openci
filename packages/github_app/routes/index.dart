import 'dart:convert';

import 'package:dart_firebase_admin/firestore.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dotenv/dotenv.dart';
import 'package:github/github.dart';
import 'package:uuid/uuid.dart';

import '../bin/env/model/env_model.dart';
import '../bin/firebase/firebase_service.dart';
import '../bin/github/model/action_type.dart';
import '../bin/job/model/job_v2_model.dart';
import '../bin/jwt_service.dart';
import '../bin/workflow/model/workflow_model.dart';

import '../bin/job/model/job_v2_model.dart' as job;

Future<Response> onRequest(RequestContext context) async {
  final env = EnvModel.fromEnvironment(
    DotEnv(includePlatformEnvironment: true)..load(),
  );

  final firestore = getFirestore(
    initializeFirebaseAdminSDK(
      env.firebaseServiceAccountBase64,
      env.firebaseProjectName,
    ),
  );

  final body = await context.request.body();
  final data = jsonDecode(body) as Map<String, dynamic>;
  final action = ActionType.values.byName(data['action'].toString());
  print('action: $action');
  final fullName = data['repository']['full_name'].toString();
  final installationId = data['installation']['id'] as int;
  final token =
      await accessToken(installationId, env.pemBase64, env.githubAppId);
  final github = GitHub(auth: Authentication.withToken(token));
  final slug = RepositorySlug.full(fullName);

  if ((action == ActionType.opened || action == ActionType.reopened) &&
      data['pull_request'] != null) {
    await handlePullRequestAction(
      data,
      firestore,
      github,
      slug,
      env,
      installationId,
    );
  }
  // else if (action == ActionType.created && data['comment'] != null) {
  //   final commentBody = data['comment']['body'] ?? '';
  //   if (commentBody.contains('/rebuild')) {
  //     // await handleRebuildComment(
  //     //     data, firestore, github, slug, env, installationId);
  //   }
  // }

  return Response(body: 'Success');
}

Future<void> handlePullRequestAction(
  Map<String, dynamic> data,
  Firestore firestore,
  GitHub github,
  RepositorySlug slug,
  EnvModel env,
  int installationId,
) async {
  final pullRequest =
      PullRequest.fromJson(data['pull_request'] as Map<String, dynamic>);
  final head = pullRequest.head;
  final base = pullRequest.base;
  final repositoryName = head?.repo?.name;
  if (repositoryName == null) {
    throw Exception('repositoryName is null');
  }
  final headSha = head?.sha;
  if (headSha == null) {
    throw Exception('headSha is null');
  }

  final repositoryUrl = head?.repo?.htmlUrl;
  final baseRef = base?.ref;
  final headRef = head?.ref;

  if (baseRef == null || headRef == null) {
    throw Exception('baseRef or headRef is null');
  }

  if (repositoryUrl == null) {
    throw Exception('cloneUrl is null');
  }

  final qs = await getWorkflowQuerySnapshot(
    firestore: firestore,
    githubRepositoryUrl: repositoryUrl,
    triggerType: 'pullRequest',
  );

  for (final docs in qs.docs) {
    final workflow = WorkflowModel.fromJson(docs.data());
    final result = await github.checks.checkRuns.createCheckRun(
      slug,
      name: workflow.workflowName,
      headSha: headSha,
      startedAt: DateTime.now(),
    );
    final branch = job.Branch(baseBranch: headRef, buildBranch: baseRef);

    final checkRunId = result.id;
    if (checkRunId == null) {
      throw Exception('checkRunId is null');
    }

    final githubChecks = job.GithubChecks(
      checkRunId: checkRunId,
      issueNumber: pullRequest.number,
    );

    final owner = head?.repo?.owner?.login;

    if (owner == null) {
      throw Exception('owner is null');
    }

    final jobGitHub = job.Github(
      appId: int.parse(env.githubAppId),
      repositoryUrl: repositoryUrl,
      owner: owner,
      repositoryName: repositoryName,
      installationId: installationId,
    );

    final jobData = job.JobV2Model(
      buildStatus: const BuildStatus(),
      branch: branch,
      githubChecks: githubChecks,
      github: jobGitHub,
      documentId: const Uuid().v4(),
      platform: workflow.platform,
      workflowId: docs.id,
      createdAt: Timestamp.now(),
    );

    final jobDataJson = {
      'buildStatus': jobData.buildStatus.toJson(),
      'branch': jobData.branch.toJson(),
      'githubChecks': jobData.githubChecks.toJson(),
      'github': jobData.github.toJson(),
      'documentId': jobData.documentId,
      'platform': jobData.platform.name,
      'workflowId': jobData.workflowId,
      'createdAt': jobData.createdAt,
    };

    await firestore
        .collection('jobs_v3')
        .doc(jobData.documentId)
        .set(jobDataJson);
  }
}
