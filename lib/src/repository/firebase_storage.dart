import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'dart:io';

class FireStorageService extends ChangeNotifier {
  final FirebaseStorage _instance = FirebaseStorage.instance;

  FirebaseStorage get getInstance => _instance;

  FireStorageService.instance();

  Future getImage(String image) async {
    return await _instance.ref().child(image).getDownloadURL() as String;
  }

  Future<void> uploadImage(PickedFile picked, String name) async {
    final File file = File(picked.path);
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child(name);
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.onComplete;
  }
}
