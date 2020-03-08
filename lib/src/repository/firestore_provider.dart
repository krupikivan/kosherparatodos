import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {

  Firestore _firestore = Firestore.instance;

  Future<QuerySnapshot> isAuthenticated(String email) {
    return _firestore.collection('users').where('email', isEqualTo: email).getDocuments();
  }

  Stream<DocumentSnapshot> getUserData(String userUID) {
    return _firestore.collection('users').document(userUID).snapshots();
  }
  
  Future<QuerySnapshot> getPedido(String userUID) {
    return _firestore.collection('historial').where('cliente', isEqualTo: userUID).getDocuments();
  }

  Future<QuerySnapshot> getDetallePedido(String userUID) {
    return _firestore.collection('historial').document(userUID).collection('detalle').getDocuments();
  }

  Future<QuerySnapshot> getProductList() {
    return _firestore.collection('producto').getDocuments();
  }
  
}