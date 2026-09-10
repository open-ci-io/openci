import 'dart:io';

import 'package:genuineci_cli/src/commands/sync/find_workflow_directory.dart';
import 'package:test/test.dart';

void main() {
  late Directory project;
  late Directory workflows;

  setUp(() async {
    project = await Directory.systemTemp.createTemp('genuineci-workflows-');
    workflows = Directory('${project.path}/.genuineci');
  });

  tearDown(() => project.delete(recursive: true));

  test(
    'finds .genuineci without requiring an OpenCI server checkout',
    () async {
      await workflows.create();

      expect(findWorkflowDirectory(project)?.path, workflows.path);
    },
  );

  test('finds .genuineci from a nested application directory', () async {
    await workflows.create();
    final nested = await Directory(
      '${project.path}/apps/example/lib',
    ).create(recursive: true);

    expect(findWorkflowDirectory(nested)?.path, workflows.path);
  });

  test('finds .genuineci when invoked inside the workflow directory', () async {
    final nested = await Directory(
      '${workflows.path}/helpers',
    ).create(recursive: true);

    expect(findWorkflowDirectory(workflows)?.path, workflows.path);
    expect(findWorkflowDirectory(nested)?.path, workflows.path);
  });

  test('prefers the nearest project with a .genuineci directory', () async {
    await workflows.create();
    final innerProject = await Directory(
      '${project.path}/examples/nested',
    ).create(recursive: true);
    final innerWorkflows = await Directory(
      '${innerProject.path}/.genuineci',
    ).create();

    expect(findWorkflowDirectory(innerProject)?.path, innerWorkflows.path);
  });

  test('returns null when no workflow directory exists', () {
    expect(findWorkflowDirectory(project), isNull);
  });

  test('does not treat a file named .genuineci as a directory', () async {
    await File(workflows.path).writeAsString('not a directory');

    expect(findWorkflowDirectory(project), isNull);
  });
}
