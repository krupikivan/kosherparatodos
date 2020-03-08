import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {

  Firestore _firestore = Firestore.instance;

  Future<QuerySnapshot> isAuthenticated(String email) {
    return _firestore.collection('users').where('email', isEqualTo: email).getDocuments();
  }

}