import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:dartssh2/dartssh2.dart';
import 'package:github/github.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:runner/src/models/job/job_model.dart';
import 'package:runner/src/services/process/process_service.dart';
import 'package:runner/src/services/shell/local_shell_service.dart';
import 'package:runner/src/services/ssh/ssh_service.dart';
import 'package:runner/src/services/supabase/supabase_service.dart';
import 'package:runner/src/services/tart/tart_service.dart';
import 'package:runner/src/services/uuid/uuid_service.dart';
import 'package:runner/src/services/vm_service.dart';
import 'package:signals_core/signals_core.dart';
import 'package:supabase/supabase.dart';
import 'package:http/http.dart' as http;
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

import 'package:path/path.dart' as path;

final runnerDir = path.join('/Users/admin/Desktop', 'actions-runner');
const runnerUrl =
    'https://github.com/actions/runner/releases/download/v2.317.0/actions-runner-osx-arm64-2.317.0.tar.gz';

Future<String> accessToken(
    int installationId, String base64Pem, int githubAppId) async {
  try {
    print('installationId: $installationId');
    print('base64Pem: $base64Pem');
    print('githubAppId: $githubAppId');
    final pem = utf8.decode(base64Decode(base64Pem));
    final file = File('./github.pem');
    file.writeAsStringSync(pem);

    final privateKeyString = File('./github.pem').readAsStringSync();
    final privateKey = RSAPrivateKey(privateKeyString);

    final jwt = JWT(
      {
        'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000, // 発行時間
        'exp':
            DateTime.now().add(Duration(minutes: 10)).millisecondsSinceEpoch ~/
                1000, // 有効期限
        'iss': githubAppId,
      },
    );

    final token = jwt.sign(privateKey, algorithm: JWTAlgorithm.RS256);

    final response = await http.post(
      Uri.parse(
          'https://api.github.com/app/installations/$installationId/access_tokens'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
        HttpHeaders.acceptHeader: 'application/vnd.github.v3+json',
      },
    );

    if (response.statusCode == 201) {
      final accessToken = jsonDecode(response.body)['token'];
      print('Access token: $accessToken');
      return accessToken;
    } else {
      print('Failed to retrieve access token: ${response.body}');
      throw Exception('Failed to retrieve access token: ${response.body}');
    }
  } catch (e) {
    print('Error: ${e.toString()}');
    throw Exception('Error: ${e.toString()}');
  }
}

Future<void> setupJITRunner(String orgName) async {
  final github = GitHub(
      auth: Authentication.withToken(githubInstallationTokenSignal.value!));
  final runnerName = UuidService.generateV4();
  print('Runner Name: $runnerName');

  try {
    print(
        'owner: ${jobSignal.value!.github_org_name}, repo: ${jobSignal.value!.github_repo_name}');
    final response = await github.request(
      'POST',
      '/repos/${jobSignal.value!.github_org_name}/${jobSignal.value!.github_repo_name}/actions/runners/generate-jitconfig',
      body: jsonEncode({
        'owner': jobSignal.value!.github_org_name,
        'repo': jobSignal.value!.github_repo_name,
        'name': runnerName,
        'runner_group_id': 1,
        'labels': [
          githubRunnerLabelSignal.value,
        ],
        'work_folder': '_work',
      }),
      headers: {
        'X-GitHub-Api-Version': '2022-11-28',
        'Content-Type': 'application/json',
      },
      params: {'org': orgName},
    );

    print('Response: ${response.statusCode}');
    print('Body: ${response.body}');
    final data = jsonDecode(response.body);
    encodedJitConfigSignal.value = data['encoded_jit_config'];
  } catch (e) {
    print('Error: $e');
  }
}

Future<void> setupRunner(
  SSHClient client,
) async {
  try {
    print('Creating runner directory...');
    final sshService = sshServiceSignal.value;

    await execCommand(client, 'mkdir -p $runnerDir');

    print('Downloading runner package...');
    await sshService.shellV2(
      client,
      'cd $runnerDir && curl -o actions-runner-osx-x64-2.317.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.317.0/actions-runner-osx-x64-2.317.0.tar.gz',
    );

    print('Extracting runner package...');
    await sshService.shellV2(
      client,
      'cd $runnerDir && tar xzf ./actions-runner-osx-x64-2.317.0.tar.gz',
    );
    print('Starting runner...');
    final configCommand =
        'cd $runnerDir && ./run.sh --jitconfig ${encodedJitConfigSignal.value}';
    await sshService.shellV2(
      client,
      configCommand,
    );

    print('GitHub Actions Runner has been set up and started successfully.');
  } catch (error) {
    print('Error setting up GitHub Actions Runner: $error');
  }
}

Future<bool> verifyRunnerStatus(SSHClient client, String pid) async {
  // 最大60秒間、1秒おきにプロセスの状態を確認
  for (int i = 0; i < 60; i++) {
    String status = await execCommand(client, 'ps -p $pid -o stat=');
    if (status.trim().isNotEmpty) {
      // プロセスが実行中
      return true;
    }
    await Future.delayed(Duration(seconds: 1));
  }
  // タイムアウト
  return false;
}

Future<String> execCommand(SSHClient client, String command,
    {String? input}) async {
  final result = await client.execute(command);

  if (input != null) {
    result.stdin.add(utf8.encode(input));
    await result.stdin.close();
  }

  final output = await result.stdout.transform(utf8Decoder).join();
  final error = await result.stderr.transform(utf8Decoder).join();
  if (error.isNotEmpty) {
    print('STDERR: $error');
  }

  if (result.exitCode != 0) {
    throw Exception('Command failed: $command (Exit code: ${result.exitCode})');
  }

  return output;
}

final utf8Decoder = StreamTransformer<Uint8List, String>.fromHandlers(
  handleData: (data, sink) {
    sink.add(utf8.decode(data));
  },
);

class AppArgs {
  AppArgs({
    required this.supabaseUrl,
    required this.supabaseAPIKey,
    required this.pemBase64,
  });
  final String supabaseUrl;
  final String supabaseAPIKey;
  final String pemBase64;
}

Future<AppArgs> initializeApp(ArgResults? argResults) async {
  if (argResults == null) {
    throw Exception('ArgResults is null');
  }
  final supabaseUrl = argResults['supabaseUrl'] as String;
  final supabaseAPIKey = argResults['supabaseAPIKey'] as String;
  final githubPEM = argResults['githubPEM'] as String;

  return AppArgs(
    supabaseUrl: supabaseUrl,
    supabaseAPIKey: supabaseAPIKey,
    pemBase64: githubPEM,
  );
}

final shouldExitSignal = signal(false);
final isSearchingSignal = signal(false);
final progressSignal = signal<Progress?>(null);
final workingVMNameSignal = signal(UuidService.generateV4());
final supabaseRowIdSignal = signal<int?>(null);
final sshClientSignal = signal<SSHClient?>(null);
final workflowRunIdSignal = signal<int?>(null);
final jobSignal = signal<JobModel?>(null);
final encodedJitConfigSignal = signal<String?>(null);
final githubRunnerLabelSignal = signal('openci-macos-m1-mini');
final githubAppIdSignal = signal(894196);
final githubInstallationTokenSignal = signal<String?>(null);
final githubPemBase64Signal = signal<String?>(null);

final isDebugSignal = signal(false);

class RunnerCommand extends Command<int> {
  RunnerCommand({
    required Logger logger,
  }) : _logger = logger {
    argParser
      ..addOption(
        'supabaseUrl',
        help: 'Supabase URL',
        abbr: 'u',
      )
      ..addOption(
        'supabaseAPIKey',
        help: 'Supabase API Key',
        abbr: 'k',
      )
      ..addOption(
        'githubPEM',
        help: 'GitHub PEM',
        abbr: 'p',
      );
  }

  @override
  String get description => 'Open CI core command';

  @override
  String get name => 'run';

  final Logger _logger;

  @override
  Future<int> run() async {
    final appArgs = await initializeApp(argResults);
    githubPemBase64Signal.value = appArgs.pemBase64;
    final supabaseService = supabaseServiceSignal.value;
    final supabaseClient = await supabaseService.initSupabase(
      url: appArgs.supabaseUrl,
      key: appArgs.supabaseAPIKey,
    );
    _logger.success('Argument check passed.');

    processServiceSignal.value.watchKeyboardSignals();
    final vmService = _vmService;

    while (!shouldExitSignal.value) {
      try {
        final isJobAvailable = await startJobSearch(supabaseClient, _logger);
        if (isJobAvailable == false) {
          continue;
        }

        final vmIP = await vmService.startVM();
        await sshServiceSignal.value.sshToServer(vmIP);

        await setupJITRunner(jobSignal.value!.github_org_name);

        await setupRunner(sshClientSignal.value!);

        while (true) {
          print('Workflow Run ID: ${workflowRunIdSignal.value}');
          final res = await supabaseClient
              .from('jobs')
              .select()
              .eq('status', 'completed')
              .eq('workflow_run_id', workflowRunIdSignal.value!)
              .limit(1);

          if (res.isNotEmpty) {
            break;
          }

          _logger.info(
              '${DateTime.now()} - Job is still running..., Workflow Run ID: ${workflowRunIdSignal.value}');
          await Future<void>.delayed(const Duration(seconds: 1));
        }
        await vmService.stopVM();
        await setCompleted(supabaseClient);
      } catch (e, s) {
        handleException(e, s, _logger);
        await setCompleted(supabaseClient);
        continue;
      }
    }
    exit(0);
  }
}

Future<void> setCompleted(SupabaseClient supabase) async {
  await supabase
      .from('jobs')
      .update({'status': 'completed'}).eq('id', supabaseRowIdSignal.value!);
}

void handleException(dynamic e, StackTrace s, Logger logger) async {
  logger
    ..err('CLI crashed: $e')
    ..err('StackTrace: $s');

  await Future<void>.delayed(const Duration(seconds: 2));

  logger.warn('Restarting the CLI...');
}

VMService get _vmService {
  final localShellService = LocalShellService();
  final tartService = TartService(localShellService);
  return VMService(tartService);
}

Future<bool> startJobSearch(
    SupabaseClient supabaseClient, Logger _logger) async {
  final retrySecond = 1;
  if (!isSearchingSignal.value) {
    _logger.info('Starting job search');
    progressSignal.value = _logger.progress('Searching for new job');
    isSearchingSignal.value = true;
  }

  PostgrestList data;

  if (isDebugSignal.value) {
    data = await supabaseClient
        .from('jobs')
        .update({'status': 'processing'})
        .order('created_at', ascending: true)
        .limit(1)
        .select();
  } else {
    data = await supabaseClient
        .from('jobs')
        .update({'status': 'processing'})
        .eq('status', 'queued')
        .order('created_at', ascending: true)
        .limit(1)
        .select();
  }

  if (data.isEmpty && progressSignal.value != null) {
    progressSignal.value
        ?.update('No jobs were found, retrying in $retrySecond seconds');

    await Future<void>.delayed(Duration(seconds: retrySecond));
    return false;
  }

  supabaseRowIdSignal.value = data.first['id'] as int;
  final job = JobModel.fromJson(data.first);
  jobSignal.value = job;
  final installationToken = await accessToken(job.github_installation_id,
      githubPemBase64Signal.value!, githubAppIdSignal.value);
  githubInstallationTokenSignal.value = installationToken;
  workflowRunIdSignal.value = job.workflow_run_id;
  progressSignal.value?.complete('New job found: $job');
  isSearchingSignal.value = false;
  return true;
}
