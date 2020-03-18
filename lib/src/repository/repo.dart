import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:kosherparatodos/src/repository/firestore_provider.dart';

abstract class Repository {
  // final _firestoreProvider = FirestoreProvider();

  Future<QuerySnapshot> isAuthenticated(String email); 
      // _firestoreProvider.isAuthenticated(email);

  Stream<DocumentSnapshot> getUserData(String userUID);
      // _firestoreProvider.getUserData(userUID);

  Future<QuerySnapshot> getPedido(String userUID);
      // _firestoreProvider.getPedido(userUID);

  Future<QuerySnapshot> getDetallePedido(String userUID);
      // _firestoreProvider.getDetallePedido(userUID);
  
  Future<QuerySnapshot> getProductList();
      // _firestoreProvider.getProductList();

  Future<QuerySnapshot> getProductoConcreto(String productoID);
      // _firestoreProvider.getProductoConcreto(productoID);

}