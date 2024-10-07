import 'package:dart_firebase_admin/firestore.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dotenv/dotenv.dart';
import 'package:github/github.dart';
import 'package:openci_models/openci_models.dart';

import '../bin/firebase/firebase_service.dart';
import '../bin/jwt_service.dart';

enum ChecksStatus {
  inProgress,
  failure,
  success,
}

const jobsDomain = 'build_jobs';

Future<void> markBuildAsStarted(
  String jobDocumentId,
  Firestore firestore,
) async {
  await firestore.collection(jobsDomain).doc(jobDocumentId).update({
    'buildStatus': 'inProgress',
  });
}

Future<void> markJobAsFailed(String jobDocumentId, Firestore firestore) async {
  await firestore.collection(jobsDomain).doc(jobDocumentId).update({
    'buildStatus': 'failure',
  });
}

Future<void> markJobAsSuccess(String jobDocumentId, Firestore firestore) async {
  await firestore.collection(jobsDomain).doc(jobDocumentId).update({
    'buildStatus': 'success',
  });
}

Future<Response> onRequest(RequestContext context) async {
  try {
    final request = context.request;

    final env = EnvModel.fromEnvironment(
      DotEnv(includePlatformEnvironment: true)..load(),
    );

    final body = await request.json() as Map<String, dynamic>;
    final jobId = body['jobId'] as String;
    final checksStatus =
        ChecksStatus.values.byName(body['checksStatus'].toString());

    final firestore = getFirestore(
      initializeFirebaseAdminSDK(
        env.firebaseServiceAccountBase64,
        env.firebaseProjectName,
      ),
    );
    print('Firestore initialized');

    final docs = await firestore.collection(jobsDomain).doc(jobId).get();
    final data = docs.data();
    if (data == null) {
      throw Exception('data is null');
    }
    print('Job data retrieved');

    final jobData = BuildJob.fromJson(data);

    final token = await accessToken(
      jobData.github.installationId,
      env.pemBase64,
      env.githubAppId,
    );
    print('GitHub token retrieved: $token');

    final github = GitHub(auth: Authentication.withToken(token));
    final slug = RepositorySlug.full(
      '${jobData.github.owner}/${jobData.github.repositoryName}',
    );

    final existingCheckRun = await github.checks.checkRuns
        .getCheckRun(slug, checkRunId: jobData.github.checkRunId);
    print('Existing check run retrieved');

    final checkRuns = github.checks.checkRuns;

    switch (checksStatus) {
      case ChecksStatus.inProgress:
        await markBuildAsStarted(jobId, firestore);
        await checkRuns.updateCheckRun(
          slug,
          existingCheckRun,
          status: CheckRunStatus.inProgress,
        );
      case ChecksStatus.failure:
        await markJobAsFailed(jobId, firestore);
        await checkRuns.updateCheckRun(
          slug,
          existingCheckRun,
          status: CheckRunStatus.inProgress,
          completedAt: DateTime.now(),
          conclusion: CheckRunConclusion.failure,
        );
      case ChecksStatus.success:
        await markJobAsSuccess(jobId, firestore);
        await checkRuns.updateCheckRun(
          slug,
          existingCheckRun,
          status: CheckRunStatus.inProgress,
          completedAt: DateTime.now(),
          conclusion: CheckRunConclusion.success,
        );
    }
    print('Check run updated');

    // if (checksStatus == ChecksStatus.success) {
    //   final workflowId = jobData.workflowId;
    //   final workflowDocumentSnapshot =
    //       await firestore.collection('workflows_v1').doc(workflowId).get();
    //   final workflowData = workflowDocumentSnapshot.data();
    //   if (workflowData == null) {
    //     throw Exception('Workflow data is null');
    //   }
    //   final workflow = WorkflowModel.fromJson(workflowData);
    //   final organizationId = workflow.organizationId;
    //   final orgDocs =
    //       await firestore.collection('organizations').doc(organizationId).get();
    //   final orgData = orgDocs.data();
    //   if (orgData == null) {
    //     throw Exception('Org data is null');
    //   }

    //   final buildNumber = orgData['buildNumber']! as Map<String, dynamic>;
    //   final platformBuildNumber = switch (jobData.platform) {
    //     OpenCITargetPlatform.ios => buildNumber['ios'],
    //     OpenCITargetPlatform.android => buildNumber['android'],
    //   };

    //   final issueNumber = jobData.githubChecks.issueNumber;
    //   if (issueNumber == null) {
    //     throw Exception('Issue number is null');
    //   }

    //   await github.issues.createComment(
    //     slug,
    //     issueNumber,
    //     'Build number: $platformBuildNumber for ${jobData.platform}',
    //   );

    //   print('issue commented');
    // }

    return Response(body: 'Success');
  } catch (e, s) {
    print('Error: $e, StackTrace: $s');
    return Response(
      body: 'Error: $e, StackTrace: $s',
      statusCode: 500,
    );
  }
}
