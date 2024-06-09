import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:openci_models/openci_models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'create_workflow_controller.g.dart';

@riverpod
class CreateWorkflowController extends _$CreateWorkflowController {
  @override
  void build() {
    return;
  }

  Future<String?> uploadFile() async {
    final projectId = await _getProjectId();
    final ref = await _putFile(projectId);
    return _getDownloadUrl(ref);
  }

  Future<String> _getProjectId() async {
    final qs = await FirebaseFirestore.instance
        .collection('organizations')
        .where('editors', arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .limit(1)
        .get();
    return qs.docs.first.id;
  }

  Future<String?> _getDownloadUrl(Reference? ref) async {
    if (ref == null) {
      return null;
    }

    return ref.getDownloadURL();
  }

  Future<Reference?> _putFile(String projectId) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return null;
    }

    // Get the selected file
    final file = result.files.first;

    // Create a reference to the file in Firebase Storage
    final storageRef =
        FirebaseStorage.instance.ref().child('/users/$projectId/${file.name}');

    try {
      await storageRef.putFile(File(file.path!));
    } on FirebaseException catch (e) {
      print(e);
    }

    return storageRef;
  }

  Future<void> save(WorkflowModel data) async {
    final res = await FirebaseFirestore.instance
        .collection('workflows_v1')
        .add(data.toJson());
    await FirebaseFirestore.instance
        .collection('workflows_v1')
        .doc(res.id)
        .update({
      'documentId': res.id,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
