import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kosherparatodos/src/models/categoria.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/models/producto.dart';
// import 'package:kosherparatodos/src/repository/firestore_provider.dart';

abstract class Repository {
  // final _firestoreProvider = FirestoreProvider();
  
//USER---------------------------------------------------------------------USER

  Future<QuerySnapshot> isAuthenticated(String email); 
      // _firestoreProvider.isAuthenticated(email);

  Stream<DocumentSnapshot> getUserData(String userUID);
      // _firestoreProvider.getUserData(userUID);

  StreamSubscription<QuerySnapshot> getPedido(String userUID);
      // _firestoreProvider.getPedido(userUID);
  
  StreamSubscription<QuerySnapshot> getProductList();
      // _firestoreProvider.getProductList();

  Future<bool> getUserAdmin(String id);

  Future<void> addNewPedido(Pedido pedido, String userId);
  
  Future<void> deletePedido(String idPedido);


//ADMIN---------------------------------------------------------------------ADMIN

  Future<QuerySnapshot> getClientes();

  // Future<QuerySnapshot> getPedidos();

  StreamSubscription<QuerySnapshot> getPedidos();

  StreamSubscription<DocumentSnapshot> getEstadoEntrega();

  StreamSubscription<QuerySnapshot> getCategorias();

  StreamSubscription<DocumentSnapshot> getClientePedido(String idCliente);

  Stream<DocumentSnapshot> getUsersAdmin();

  // Future<DocumentSnapshot> getClienteSpecific(String id);

  Future<void> setPagado(String idPedido, bool pagado);
  
  Future<void> setEstadoEntrega(String idPedido, String value);
  
  Future<void> setAutenticado(String idCliente, bool autenticado);

  Future<void> addNewProducto(Producto newProducto);
  
  Future<void> addNewCategoria(Categoria newCategoria);
  
  Future<void> deleteProducto(String idProducto);

  Future<void> setHabilitado(String idProducto, bool habilitado);
  
  Future<void> updateAllData(Producto producto);
  
  
  Future getCategoriasPrincipal();
  
  Future getAllCategorias();
  
  Future getCategoriasHijos(String idPadre);
  
  Future getProductosFromHijoSelected(String idHijo);
}