import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kosherparatodos/src/repository/firestore_provider.dart';

class Repository {
  final _firestoreProvider = FirestoreProvider();

  Future<QuerySnapshot> isAuthenticated(String email) =>
      _firestoreProvider.isAuthenticated(email);

}

final repo = Repository();