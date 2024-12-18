import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:openci_models/openci_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'secret_page_controller.g.dart';

@riverpod
class SecretPageController extends _$SecretPageController {
  @override
  void build() {
    return;
  }
}

@riverpod
Stream<QuerySnapshot> secretStream(Ref ref) {
  return FirebaseFirestore.instance
      .collection(secretsCollectionPath)
      .where(
        'owners',
        arrayContains: FirebaseAuth.instance.currentUser!.uid,
      )
      .snapshots();
}
