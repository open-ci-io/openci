import 'package:runner/src/features/build_job/models/job_status.dart';
import 'package:runner/src/models/build_job/build_job.dart';
import 'package:supabase/supabase.dart';

Future<void> setJobStatus(
  SupabaseClient supabase,
  BuildJob job,
  JobStatus status,
) async {
  await supabase
      .from('build_jobs')
      .update({'status_v2': status.name}).eq('id', job.id);
}
