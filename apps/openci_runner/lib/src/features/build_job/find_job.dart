import 'package:runner/src/features/build_job/models/job_status.dart';
import 'package:runner/src/models/build_job/build_job.dart';
import 'package:supabase/supabase.dart';

Future<BuildJob?> findJob(
  SupabaseClient supabaseClient,
) async {
  final data = await supabaseClient
      .from('build_jobs')
      .select()
      .eq('status_v2', JobStatus.waiting.name)
      .limit(1);

  if (data.isEmpty) {
    return null;
  }

  return BuildJob.fromJson(data.first);
}
