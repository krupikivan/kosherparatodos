import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kosherparatodos/src/models/categoria.dart';
import 'package:kosherparatodos/src/models/cliente.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/models/producto.dart';

import '../models/categoria.dart';
// import 'package:kosherparatodos/src/repository/firestore_provider.dart';

abstract class Repository {
//----------------------------------------------------------
//------------------------USER------------------------------
//----------------------------------------------------------
  Future<QuerySnapshot> isAuthenticated(String email);

  Stream<DocumentSnapshot> getUserData(String userUID);

  Future<QuerySnapshot> getPedidosCliente(String clienteID);

  Future<QuerySnapshot> getProductosHabilitados();

  Future<void> addNewPedido(Pedido pedido, Cliente cliente);

  Future<void> changeCategoryName(Categoria categoria, String name);

  Future<bool> getUserAdmin(String id);

  Future<void> eliminarPedido(Pedido pedidoSelected);

//----------------------------------------------------------
//------------------------ADMIN------------------------------
//----------------------------------------------------------

  Future<QuerySnapshot> getClientes();

  Future<QuerySnapshot> getAllCategorias();

  StreamSubscription<QuerySnapshot> getAllPedidos();

  Future<DocumentSnapshot> getDatosUtiles();

  StreamSubscription<QuerySnapshot> getCategorias();

  StreamSubscription<DocumentSnapshot> getClientePedido(String idCliente);

  Stream<DocumentSnapshot> getUsersAdmin();

  Future<void> setPagado(String idPedido, {bool pagado});

  Future<void> changeImageUrl(Producto producto);

  Future<void> setEstadoEntrega(String idPedido, EnumEntrega value);

  Future<void> setAutenticado(String idCliente, {bool autenticado});

  Future<void> addNewProducto(Producto newProducto);

  Future<void> addNewCategoria(Categoria newCategoria);

  Future<void> addUserAddress(Cliente cliente);

  Future<void> deleteProducto(String idProducto);

  Future<void> setHabilitado(String idProducto, {bool habilitado});

  Future<void> updateAllData(Producto producto);

  Future<QuerySnapshot> getCategoriasPrincipal();

  Future<QuerySnapshot> getAllCategoriasHijos();

  Future<QuerySnapshot> getCategoriasHijos(String idPadre);

  Future<QuerySnapshot> getProductosFromHijoSelected(String idHijo);
}
