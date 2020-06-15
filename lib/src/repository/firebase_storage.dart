import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FireStorageService extends ChangeNotifier {
  final FirebaseStorage _instance = FirebaseStorage.instance;

  FirebaseStorage get getInstance => _instance;

  FireStorageService.instance();

  Future getImage(String image) async {
    return await _instance.ref().child(image).getDownloadURL() as String;
  }
}
