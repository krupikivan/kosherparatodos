import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kosherparatodos/src/models/producto.dart';
// import 'package:kosherparatodos/src/repository/firestore_provider.dart';

abstract class Repository {
  // final _firestoreProvider = FirestoreProvider();
  
//USER---------------------------------------------------------------------USER

  Future<QuerySnapshot> isAuthenticated(String email); 
      // _firestoreProvider.isAuthenticated(email);

  Stream<DocumentSnapshot> getUserData(String userUID);
      // _firestoreProvider.getUserData(userUID);

  Future<QuerySnapshot> getPedido(String userUID);
      // _firestoreProvider.getPedido(userUID);

  Future<QuerySnapshot> getDetallePedido(String userUID);
      // _firestoreProvider.getDetallePedido(userUID);
  
  StreamSubscription<QuerySnapshot> getProductList();
      // _firestoreProvider.getProductList();

  StreamSubscription<QuerySnapshot> getProductoConcreto(String productoID);
      // _firestoreProvider.getProductoConcreto(productoID);

  Future<bool> getUserAdmin(String id);

//ADMIN---------------------------------------------------------------------ADMIN

  Future<QuerySnapshot> getClientes();

  // Future<QuerySnapshot> getPedidos();

  StreamSubscription<QuerySnapshot> getPedidos();
  
  StreamSubscription<QuerySnapshot> getDetallePedidoActual(String idPedido);

  StreamSubscription<DocumentSnapshot> getClientePedido(String idCliente);

  Stream<DocumentSnapshot> getUsersAdmin();

  // Future<DocumentSnapshot> getClienteSpecific(String id);

  Future<void> setPagado(String idPedido, bool pagado);

  Future<void> addNewProducto(Producto newProducto);
  
  Future<void> deleteProducto(String idProducto);

  Future<void> setHabilitado(String idProducto, bool habilitado);
  
  Future<void> updateAllData(Producto producto);
}