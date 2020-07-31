import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class FireStorageService extends ChangeNotifier {
  final FirebaseStorage _instance = FirebaseStorage.instance;

  FirebaseStorage get getInstance => _instance;

  FireStorageService.instance();

  Future getImage(String image) async {
    try {
      return await _instance.ref().child(image).getDownloadURL() as String;
    } catch (e) {
      return "";
    }
  }

  Future<void> uploadImage(File picked, String name) async {
    final StorageReference storageReference =
        FirebaseStorage.instance.ref().child(name);
    final StorageUploadTask uploadTask = storageReference.putFile(picked);
    await uploadTask.onComplete;
  }
}
