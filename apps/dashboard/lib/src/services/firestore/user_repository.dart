import 'package:dashboard/src/features/navigation/presentation/navigation_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:openci_models/openci_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_repository.g.dart';

@riverpod
class UserRepository extends _$UserRepository {
  @override
  void build() {
    return;
  }

  Future<OpenCIUser> getUser() async {
    final suite = await getOpenCIFirebaseSuite();
    final user = suite.auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'User not found',
      );
    }
    final docs = await suite.firestore
        .collection(usersCollectionPath)
        .doc(user.uid)
        .get();
    return OpenCIUser.fromJson(docs.data()!);
  }
}
