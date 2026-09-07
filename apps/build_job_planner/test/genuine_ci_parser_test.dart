import 'package:build_job_planner/build_job_planner.dart';
import 'package:test/test.dart';

void main() {
  group('parseGenuineCiWorkflow', () {
    for (final args in [
      "workflowName: 'CI'",
      "ciTrigger: CiTrigger.push(branch: 'main')",
      "workflowName: 'CI', ciTrigger: CiTrigger.push()",
      "workflowName: 'CI', ciTrigger: CiTrigger.unknown(branch: 'main')",
      "workflowName: name, ciTrigger: CiTrigger.push(branch: 'main')",
      r"workflowName: 'CI $name', ciTrigger: CiTrigger.push(branch: 'main')",
      r"workflowName: 'CI', ciTrigger: CiTrigger.push(branch: 'release/$version')",
    ]) {
      test('does not schedule an incomplete or dynamic definition: $args', () {
        final workflow = parseGenuineCiWorkflow(
          'void main() { GenuineCI.init($args); }',
          'ci.dart',
        );

        expect(workflow, isNull);
      });
    }

    test('ignores unrelated init calls and workflow text in comments', () {
      final workflow = parseGenuineCiWorkflow('''
        // GenuineCI.init(workflowName: 'Comment', ciTrigger: CiTrigger.push(branch: '*'));
        void main() {
          SomethingElse.init(workflowName: 'Other', ciTrigger: CiTrigger.push(branch: '*'));
        }
      ''', 'ci.dart');

      expect(workflow, isNull);
    });

    test('successfully parses GenuineCI.init with push trigger', () {
      const source = '''
import 'package:genuine_ci/genuine_ci.dart';

Future<void> main() async {
  final genuineCI = await GenuineCI.init(
    workflowName: 'Unit Tests',
    ciTrigger: CiTrigger.push(branch: 'main'),
  );

  await FlutterCi.unitTest(genuineCI.workspacePath);
}
''';

      final workflow = parseGenuineCiWorkflow(source, 'unit_test.dart');

      expect(workflow, isNotNull);
      expect(workflow!.workflowName, equals('Unit Tests'));
      expect(workflow.workflowFileName, equals('unit_test.dart'));
      expect(workflow.triggerType, equals('push'));
      expect(workflow.triggerBranch, equals('main'));
    });

    test('successfully parses GenuineCI.init with pullRequest trigger', () {
      const source = '''
import 'package:genuine_ci/genuine_ci.dart';

Future<void> main() async {
  final genuineCI = await GenuineCi.init(
    workflowName: 'PR Check',
    ciTrigger: CiTrigger.pullRequest(branch: 'feature/*'),
  );
}
''';

      final workflow = parseGenuineCiWorkflow(source, 'pr_check.dart');

      expect(workflow, isNotNull);
      expect(workflow!.workflowName, equals('PR Check'));
      expect(workflow.workflowFileName, equals('pr_check.dart'));
      expect(workflow.triggerType, equals('pullRequest'));
      expect(workflow.triggerBranch, equals('feature/*'));
    });
  });

  group('ParsedWorkflow.matches', () {
    test('treats regex punctuation in branch patterns literally', () {
      const workflow = ParsedWorkflow(
        workflowFileName: 'ci.dart',
        workflowName: 'Release',
        triggerType: 'push',
        triggerBranch: 'release/v1.2+hotfix/*',
      );

      expect(
        workflow.matches(eventType: 'push', branch: 'release/v1.2+hotfix/test'),
        isTrue,
      );
      expect(
        workflow.matches(eventType: 'push', branch: 'release/v1x2hotfix/test'),
        isFalse,
      );
      expect(
        workflow.matches(
          eventType: 'push',
          branch: 'prefix/release/v1.2+hotfix/test',
        ),
        isFalse,
      );
      expect(
        workflow.matches(
          eventType: 'pull_request',
          branch: 'release/v1.2+hotfix/test',
        ),
        isFalse,
      );
    });

    const pushWorkflow = ParsedWorkflow(
      workflowFileName: 'deploy.dart',
      workflowName: 'Deploy',
      triggerType: 'push',
      triggerBranch: 'main',
    );

    const prWorkflow = ParsedWorkflow(
      workflowFileName: 'pr.dart',
      workflowName: 'PR Check',
      triggerType: 'pullRequest',
      triggerBranch: 'feature/*',
    );

    test('matches exact branch and event', () {
      expect(pushWorkflow.matches(eventType: 'push', branch: 'main'), isTrue);
      expect(
        pushWorkflow.matches(eventType: 'push', branch: 'develop'),
        isFalse,
      );
      expect(
        pushWorkflow.matches(eventType: 'pull_request', branch: 'main'),
        isFalse,
      );
    });

    test('matches wildcard branch pattern', () {
      expect(
        prWorkflow.matches(eventType: 'pull_request', branch: 'feature/auth'),
        isTrue,
      );
      expect(
        prWorkflow.matches(eventType: 'pull_request', branch: 'bugfix/123'),
        isFalse,
      );
    });
  });
}
