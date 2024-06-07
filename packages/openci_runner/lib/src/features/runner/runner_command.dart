import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:dart_firebase_admin/dart_firebase_admin.dart';
import 'package:dart_firebase_admin/firestore.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:openci_models/openci_models.dart';
import 'package:runner/src/services/build_job/aap_build_service.dart';
import 'package:runner/src/services/build_job/build_distribution_service.dart';
import 'package:runner/src/services/build_job/build_utility_service.dart';
import 'package:runner/src/services/build_job/flutter_version_manager.dart';
import 'package:runner/src/services/build_job/ipa_build_service.dart';
import 'package:runner/src/services/build_job/organization/organization_model.dart';
import 'package:runner/src/services/build_job/workflow/workflow_service.dart';
import 'package:runner/src/services/firebase/firestore/firestore_path.dart';
import 'package:runner/src/services/github_service.dart';
import 'package:runner/src/services/log/log_service.dart';
import 'package:runner/src/services/shell/local_shell_service.dart';
import 'package:runner/src/services/shell/ssh_shell_service.dart';
import 'package:runner/src/services/ssh/ssh_service.dart';
import 'package:runner/src/services/tart/tart_service.dart';
import 'package:runner/src/services/uuid/uuid_service.dart';
import 'package:runner/src/services/vm_service.dart';
import 'package:process_run/shell.dart';
import 'package:sentry/sentry.dart';

class AppConfig {
  AppConfig({
    required this.firebaseProjectName,
    required this.firebaseServiceAccountJson,
    required this.pem,
  });
  final String firebaseProjectName;
  final String firebaseServiceAccountJson;
  final String pem;
}

bool shouldExit = false;

class RunnerCommand extends Command<int> {
  RunnerCommand({
    required Logger logger,
  }) : _logger = logger {
    argParser
      ..addOption(
        'firebaseProjectName',
        help: 'Firebase Project Name',
        abbr: 'p',
      )
      ..addOption(
        'firebaseServiceAccountJson',
        help: 'Firebase Service Account Json file Path',
        abbr: 's',
      )
      ..addOption(
        'sentryDSN',
        help: "Sentry's DSN",
        abbr: 'd',
      )
      ..addOption(
        'pemFilePath',
        help: 'pem file path',
        abbr: 'f',
      );
  }

  Future<AppConfig> initializeApp(ArgResults? argResults) async {
    if (argResults == null) {
      throw Exception('ArgResults is null');
    }
    final firebaseProjectName = argResults['firebaseProjectName'] as String;
    final firebaseServiceAccountJson =
        argResults['firebaseServiceAccountJson'] as String;
    final sentryDSN = argResults['sentryDSN'] as String?;
    final pem = argResults['pemFilePath'] as String;

    await initializeSentry(sentryDSN);
    validateFirebaseProjectName(firebaseProjectName);
    validateFirebaseServiceAccountJson(firebaseServiceAccountJson);

    return AppConfig(
      firebaseProjectName: firebaseProjectName,
      firebaseServiceAccountJson: firebaseServiceAccountJson,
      pem: pem,
    );
  }

  Future<void> initializeSentry(String? sentryDSN) async {
    if (sentryDSN != null) {
      await Sentry.init((options) {
        options
          ..dsn = sentryDSN
          ..tracesSampleRate = 1.0;
      });
    }
  }

  void validateFirebaseProjectName(String firebaseProjectName) {
    if (firebaseProjectName.isEmpty) {
      _logger.err('firebaseProjectName is required');
      throw Exception('firebaseProjectName is required');
    }
  }

  void validateFirebaseServiceAccountJson(String firebaseServiceAccountJson) {
    if (firebaseServiceAccountJson.isEmpty) {
      _logger.err('firebaseServiceAccountJson is required');
      throw Exception('firebaseServiceAccountJson is required');
    }
  }

  @override
  String get description => 'Open CI core command';

  @override
  String get name => 'run';

  final Logger _logger;

  @override
  Future<int> run() async {
    final appConfig = await initializeApp(argResults);
    _logger.success('Argument check passed.');

    final admin = FirebaseAdminApp.initializeApp(
      appConfig.firebaseProjectName,
      Credential.fromServiceAccount(
        File(appConfig.firebaseServiceAccountJson),
      ),
    );

    final firestore = Firestore(
      admin,
    );

    var isSearching = false;

    Progress? progress;

    ProcessSignal.sigterm.watch().listen((signal) {
      _logger.warn('Received SIGTERM. Terminating the CLI...');
    });

    ProcessSignal.sigint.watch().listen((signal) {
      _logger.warn('Received SIGINT. Terminating the CLI...');
      shouldExit = true;
      exit(0);
    });

    while (!shouldExit) {
      try {
        if (isSearching == false) {
          _logger.info('Searching new job');
          progress = _logger.progress('Searching new job');

          isSearching = true;
        }

        final jobsQs = await firestore
            .collection(FirestorePath.jobsDomain)
            .where('buildStatus.processing', WhereFilter.equal, false)
            .where('buildStatus.success', WhereFilter.equal, false)
            .where('buildStatus.failure', WhereFilter.equal, false)
            .orderBy('createdAt', descending: true)
            .get();

        if (jobsQs.docs.isEmpty && progress != null) {
          progress.update('No jobs were found');

          await Future<void>.delayed(const Duration(seconds: 10));
          continue;
        }

        progress!.complete('New job found');
        isSearching = false;
        final jobsData = jobsQs.docs.first.data();
        final buildJob = BuildModel.fromJson(jobsData);
        final jobId = buildJob.documentId;
        final targetPlatform = buildJob.platform;
        _logger.info('targetPlatform: $targetPlatform');
        final workflowService = WorkflowService();

        final workflow = await workflowService.getWorkflowData(
          firestore,
          buildJob.workflowId,
          jobId,
        );

        String? customInfoStyle(String? m) {
          return backgroundDarkGray.wrap(styleBold.wrap(blue.wrap(m)));
        }

        _logger.info(
          'workflow: ${workflow.workflowName}',
          style: customInfoStyle,
        );

        // prepare service classes
        final localShellService = LocalShellService();
        final tartService = TartService(localShellService);
        final vmService = VMService(tartService);
        final buildUtilityService = BuildUtilityService(firestore, vmService);
        final github = GitHubService();

        final tokenId = await github.getInstallationToken(
          buildJob.github.installationId,
        );
        await buildUtilityService.markBuildAsStarted(jobId);

        final organizationDocs = await firestore
            .collection('organizations')
            .doc(workflow.organizationId)
            .get();
        final organizationData = organizationDocs.data();
        if (organizationData == null) {
          throw Exception(
            'organizationData is null: ${workflow.organizationId}',
          );
        }
        final organization = OrganizationModel.fromJson(organizationData);

        final workingVMName = UuidService.generateV4();
        await vmService.cleanupVMs();
        await vmService.cloneVM(workingVMName);
        unawaited(vmService.launchVM(workingVMName));
        while (true) {
          final shell = Shell();
          List<ProcessResult>? result;
          try {
            result = await shell.run('tart ip $workingVMName');
          } catch (e) {
            result = null;
          }
          if (result != null) {
            break;
          }
          await Future<void>.delayed(const Duration(seconds: 1));
        }
        _logger.success('VM is ready');
        final vmIP = await vmService.fetchIpAddress(workingVMName);
        final logService = LogService(firestore);

        final sshService = SSHService(logService, buildUtilityService);

        final sshClient = await sshService.sshToServer(vmIP);
        if (sshClient == null) {
          throw Exception('ssh client is null');
        }
        final sshShellService = SSHShellService(sshService);
        final appName = buildJob.github.repositoryName;

        await buildUtilityService.cloneRepository(
          sshShellService,
          sshClient,
          buildJob,
          jobId,
          workingVMName,
          tokenId,
        );

        final flutterVersionManager = FlutterVersionManager(
          sshShellService,
          sshClient,
          jobId,
          workingVMName,
          appName,
        );

        await flutterVersionManager
            .changeFlutterVersion(workflow.flutter.version);

        final buildDistributionService = BuildDistributionService(
          sshShellService,
          sshClient,
          jobId,
          workingVMName,
          appName,
        );

        if (targetPlatform == TargetPlatform.android) {
          final aabBuildService = AabBuildService(
            sshShellService,
            sshClient,
            jobId,
            workingVMName,
            appName,
          );
          final android = workflow.android;
          if (android == null) {
            throw Exception('Android is null');
          }

          await aabBuildService.downloadKeyJks(android);
          await aabBuildService.downloadKeyProperties(android.keyProperties);
          final useShorebird = workflow.shorebird.useShorebird;

          if (useShorebird != null && useShorebird == true) {
            await aabBuildService.buildShorebirdAppBundle(
              organization.buildNumber.android,
              workflow.shorebird.token,
              workflow.flutter,
            );
          } else {
            await aabBuildService.runCustomScripts();
            await aabBuildService.buildApk(
              organization.buildNumber.android,
              workflow.flutter,
            );
          }

          final distribution = workflow.distribution;

          switch (distribution) {
            case BuildDistributionChannel.firebaseAppDistribution:
              final serviceAccountJsonDownloadUrl =
                  workflow.firebase.serviceAccountJson;
              if (serviceAccountJsonDownloadUrl == null) {
                throw Exception('Service account json download url is null');
              }
              await buildUtilityService.importServiceAccountJson(
                appConfig.firebaseServiceAccountJson,
                sshShellService,
                sshClient,
                jobId,
                workingVMName,
                appName,
                serviceAccountJsonDownloadUrl,
              );
              await buildDistributionService
                  .uploadBuildToFirebaseAppDistribution(
                workflow.firebase.appIdAndroid,
                workflow.firebase.appDistribution.testerGroups,
                TargetPlatform.android,
              );
              _logger.success('upload build success');
            case BuildDistributionChannel.testFlight:
            case BuildDistributionChannel.playStoreInternal:
            case BuildDistributionChannel.playStoreBeta:
            case null:
          }
        } else if (targetPlatform == TargetPlatform.ios) {
          final ipaBuildService = IpaBuildService(
            sshShellService,
            sshClient,
            jobId,
            workingVMName,
            appName,
          );
          final workflowForIos = workflow.ios;
          if (workflowForIos == null) {
            throw Exception('workflowForIos is null');
          }

          await ipaBuildService.downloadExportOptionsPlist(
            workflowForIos.exportOptions,
          );
          await ipaBuildService.createCertificateDirectory();
          await ipaBuildService.downloadP12Certificate(
            workflowForIos.p12,
          );
          await ipaBuildService.downloadMobileProvisioningProfile(
            workflowForIos.provisioningProfile?.url,
          );
          await ipaBuildService.importCertificates();

          // await ipaBuildService.getRubyScripts(
          //   sshShellService,
          //   sshClient,
          //   jobId,
          //   vm.workingVMName,
          // );

          // await ipaBuildService.setProvisioningProfile(
          //   sshShellService,
          //   sshClient,
          //   jobId,
          //   vm.workingVMName,
          //   workflow.ios.teamId,
          //   workflow.ios.provisioningProfile?.name,
          // );

          await ipaBuildService.runCustomScripts();

          final useShorebird = workflow.shorebird.useShorebird;
          final patch = workflow.shorebird.patch;
          if (patch != null && patch) {
            final privateKey = await ipaBuildService
                .fetchPrivateKey(workflowForIos.appStoreConnectAPI?.p8);
            final data =
                await ipaBuildService.getLatestAppVersionAndBuildNumber(
              workflowForIos.appStoreConnectAPI?.appId,
              workflowForIos.appStoreConnectAPI?.keyId,
              workflowForIos.appStoreConnectAPI?.issuerId,
              privateKey,
            );

            await ipaBuildService.patchShorebirdIpa(
              int.parse(data['buildNumber'].toString()),
              workflow.shorebird.token,
              workflow.flutter,
            );
          } else {
            if (useShorebird != null && useShorebird == true) {
              await ipaBuildService.buildShorebirdIpa(
                organization.buildNumber.ios,
                workflow.shorebird.token,
                workflow.flutter,
              );
            } else {
              await ipaBuildService.buildIpa(
                organization.buildNumber.ios,
                workflow.flutter,
              );
            }

            _logger.success('ipa build success');

            final distribution = workflow.distribution;

            switch (distribution) {
              case BuildDistributionChannel.firebaseAppDistribution:
                final serviceAccountJsonDownloadUrl =
                    workflow.firebase.serviceAccountJson;
                if (serviceAccountJsonDownloadUrl == null) {
                  throw Exception('Service account json download url is null');
                }
                await buildUtilityService.importServiceAccountJson(
                  appConfig.firebaseServiceAccountJson,
                  sshShellService,
                  sshClient,
                  jobId,
                  workingVMName,
                  appName,
                  serviceAccountJsonDownloadUrl,
                );
                await buildDistributionService
                    .uploadBuildToFirebaseAppDistribution(
                  workflow.firebase.appIdIos,
                  workflow.firebase.appDistribution.testerGroups,
                  TargetPlatform.ios,
                );
                _logger.success('upload build success');
              case BuildDistributionChannel.testFlight:
                await ipaBuildService.downloadP8(
                  workflowForIos.appStoreConnectAPI?.p8,
                  workflowForIos.appStoreConnectAPI?.keyId,
                );
                await ipaBuildService.uploadIpaToTestFlight(
                  workflowForIos.appStoreConnectAPI?.keyId,
                  workflowForIos.appStoreConnectAPI?.issuerId,
                  await buildDistributionService.ipaPath(),
                );
              case BuildDistributionChannel.playStoreInternal:
              //
              case BuildDistributionChannel.playStoreBeta:
              case null:
              // TODO: Handle this case.
            }
          }
        }

        await buildUtilityService.markJobAsSuccess(jobId);
        await buildUtilityService.incrementBuildNumber(
          organization.documentId,
          organization.buildNumber,
          workflow.platform,
        );
        _logger.success('${workflow.platform} buildNumber update success');
        _logger.success('whole build process completed');

        await vmService.stopVM(workingVMName);
      } catch (e, s) {
        _logger
          ..err('CLI crashed: $e')
          ..err('StackTrace: $s');

        await Sentry.captureException(
          e,
          stackTrace: s,
        );

        await Future<void>.delayed(const Duration(seconds: 2));

        _logger.warn('Restarting the CLI...');
        continue;
      }
    }
    exit(0);
  }
}
