import 'dart:convert';

import 'package:dart_firebase_admin/firestore.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dotenv/dotenv.dart';
import 'package:github/github.dart';
import 'package:openci_models/openci_models.dart';
import 'package:uuid/uuid.dart';

import '../bin/firebase/firebase_service.dart';
import '../bin/jwt_service.dart';

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
  final action =
      OpenCIGitHubActionType.values.byName(data['action'].toString());
  final fullName = data['repository']['full_name'].toString();
  final installationId = data['installation']['id'] as int;
  final token =
      await accessToken(installationId, env.pemBase64, env.githubAppId);
  final github = GitHub(auth: Authentication.withToken(token));
  final slug = RepositorySlug.full(fullName);

  try {
    if ((action == OpenCIGitHubActionType.opened ||
            action == OpenCIGitHubActionType.reopened ||
            action == OpenCIGitHubActionType.synchronize ||
            action == OpenCIGitHubActionType.edited) &&
        data['pull_request'] != null) {
      print('Start handlePullRequestAction');
      await handlePullRequestAction(
        data,
        firestore,
        github,
        slug,
        env,
        installationId,
      );
      print('Successfully handled pull request action');
    } else {
      print('No action');
    }
  } catch (e) {
    print('Error: $e');
  }

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

  try {
    final qs = await getWorkflowQuerySnapshot(
      firestore: firestore,
      githubRepositoryUrl: repositoryUrl,
      triggerType: 'pullRequest',
    );

    for (final docs in qs.docs) {
      final workflow = WorkflowModel.fromJson(docs.data());

      if (workflow.github.baseBranch != baseRef) {
        print('base branch is not matched');
        continue;
      }

      final result = await github.checks.checkRuns.createCheckRun(
        slug,
        name: workflow.name,
        headSha: headSha,
        startedAt: DateTime.now(),
      );

      final checkRunId = result.id;
      if (checkRunId == null) {
        throw Exception('checkRunId is null');
      }

      final owner = head?.repo?.owner?.login;

      if (owner == null) {
        throw Exception('owner is null');
      }

      final jobGitHub = OpenCIGithub(
        appId: int.parse(env.githubAppId),
        repositoryUrl: repositoryUrl,
        owner: owner,
        repositoryName: repositoryName,
        installationId: installationId,
        issueNumber: pullRequest.number,
        checkRunId: checkRunId,
        baseBranch: baseRef,
        buildBranch: headRef,
      );

      final docId = const Uuid().v4();

      final jobData = BuildJob(
        buildStatus: OpenCIGitHubChecksStatus.queued,
        github: jobGitHub,
        id: docId,
        workflowId: docs.id,
        createdAt: Timestamp.now(),
      );

      final jobDataJson = {
        'buildStatus': jobData.buildStatus.name,
        'github': jobData.github.toJson(),
        'id': jobData.id,
        'workflowId': jobData.workflowId,
        'createdAt': jobData.createdAt,
      };

      await firestore.collection('build_jobs').doc(docId).set(jobDataJson);
    }
  } catch (e) {
    print('Error: $e');
  }
}
