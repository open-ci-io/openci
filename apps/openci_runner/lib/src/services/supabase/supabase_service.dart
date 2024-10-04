import 'package:signals_core/signals_core.dart';
import 'package:supabase/supabase.dart';

final supabaseServiceSignal = signal(SupabaseService());

class SupabaseService {
  Future<SupabaseClient> initSupabase({
    required String url,
    required String key,
  }) async {
    return SupabaseClient(
      url,
      key,
    );
  }
}
