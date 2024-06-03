import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  void build() {
    return;
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final res = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    print(res.user?.toString());
  }
}
