import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kosherparatodos/src/models/cliente.dart';
import 'package:kosherparatodos/src/repository/repo.dart';

class FirestoreProvider implements Repository {

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

  Future<QuerySnapshot> getDetallePedido(String pedidoID) {
    return _firestore.collection('historial').document(pedidoID).collection('detalle').getDocuments();
  }

  Future<QuerySnapshot> getProductList() {
    return _firestore.collection('producto').getDocuments();
  }
  
  Future<QuerySnapshot> getProductoConcreto(String productoID) {
    return _firestore.collection('producto').document(productoID).collection('productoConcreto').getDocuments();
  }

  Future<bool> getUserAdmin(String id)  {
   return  _firestore.collection('root').document('rootUser').get()
   .then((value){
     for(int i=0;i<value.data['userID'].length;i++){
       if(value.data['userID'][i] == id ){
         return true;
       }
     }
     return false;
   });
  }

  Future<QuerySnapshot> getClientes() {
    return _firestore.collection('users').getDocuments();
  }

  Future<QuerySnapshot> getPedidos() {
    return _firestore.collection('historial').getDocuments();
  }

  Stream<DocumentSnapshot> getUsersAdmin() {
    return _firestore.collection('root').document('rootUser').snapshots();
  }

  Future<DocumentSnapshot> getClienteSpecific(String id)  {
   return  _firestore.collection('users').document(id).get();
  }

}