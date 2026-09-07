import 'dart:async';
import 'dart:convert';

import 'package:dashboard/auth/auth_provider.dart';
import 'package:dashboard/utilities/openci_server_url_provider.dart';
import 'package:dashboard/team/selected_team_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:openci_shared/openci_shared.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

export 'package:openci_shared/openci_shared.dart';

part 'build_jobs_provider.g.dart';

@riverpod
Stream<BuildJob?> buildJobById(Ref ref, String buildJobId) async* {
  final authState = ref.watch(authStateChangesProvider);
  if (authState.value == null) {
    yield null;
    return;
  }

  final serverUrl = ref.watch(openciServerUrlProvider);
  final token = await ref.watch(authedFirebaseIdTokenProvider.future);

  BuildJob? cache;

  Future<BuildJob?> fetchJob(String token) async {
    try {
      final url = Uri.parse('$serverUrl/builds/$buildJobId');

      final response = await http
          .get(
            url,
            headers: {
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode != 200) {
        debugPrint(
          'Fetch build job by id failed with status: ${response.statusCode}',
        );
        return cache;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final job = BuildJob.fromJson(data);
      if (job.teamId != null) {
        final selectedTeamId = ref.read(selectedTeamIdProvider).value;
        if (selectedTeamId != job.teamId) {
          unawaited(
            Future.microtask(() {
              ref
                  .read(selectedTeamIdProvider.notifier)
                  .saveSelectedTeamId(job.teamId!);
            }),
          );
        }
      }
      cache = job;
      return job;
    } catch (e, s) {
      debugPrint('Error fetching build job by id: $e\n$s');
      return cache;
    }
  }

  final initialJob = await fetchJob(token);
  yield initialJob;

  yield* Stream.periodic(const Duration(seconds: 5)).asyncMap((_) async {
    return fetchJob(token);
  });
}
