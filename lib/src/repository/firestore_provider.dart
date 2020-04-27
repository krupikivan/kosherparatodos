import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kosherparatodos/src/models/cliente.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/pedido_notifier.dart';
import 'package:kosherparatodos/src/repository/repo.dart';

class FirestoreProvider implements Repository {
  Firestore _firestore = Firestore.instance;

  Future<QuerySnapshot> isAuthenticated(String email) {
    return _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .getDocuments();
  }

  Stream<DocumentSnapshot> getUserData(String userUID) {
    return _firestore.collection('users').document(userUID).snapshots();
  }

  Future<QuerySnapshot> getPedido(String userUID) {
    return _firestore
        .collection('historial')
        .where('cliente', isEqualTo: userUID)
        .getDocuments();
  }

  Future<QuerySnapshot> getDetallePedido(String pedidoID) {
    return _firestore
        .collection('historial')
        .document(pedidoID)
        .collection('detalle')
        .getDocuments();
  }

  StreamSubscription<QuerySnapshot> getProductList() {
    return _firestore.collection('producto').snapshots().listen((event) {});
  }

  StreamSubscription<QuerySnapshot> getProductoConcreto(String productoID) {
    return _firestore
        .collection('producto')
        .document(productoID)
        .collection('productoConcreto')
        .snapshots()
        .listen((event) {});
  }

  Future<bool> getUserAdmin(String id) {
    return _firestore
        .collection('root')
        .document('rootUser')
        .get()
        .then((value) {
      for (int i = 0; i < value.data['userID'].length; i++) {
        if (value.data['userID'][i] == id) {
          return true;
        }
      }
      return false;
    });
  }

  Future<QuerySnapshot> getClientes() {
    return _firestore.collection('users').getDocuments();
  }

  // Future<QuerySnapshot> getPedidos() {
  //   return _firestore.collection('historial').getDocuments();
  // }

  StreamSubscription<QuerySnapshot> getPedidos() {
    return _firestore.collection('historial').snapshots().listen((doc) {
      doc.documents.forEach((pedido) {});
    });
  }

  StreamSubscription<QuerySnapshot> getDetallePedidoActual(String idPedido) {
    return _firestore
        .collection('historial')
        .document(idPedido)
        .collection('detalle')
        .snapshots()
        .listen((doc) {
      doc.documents.forEach((pedido) {});
    });
  }

  StreamSubscription<DocumentSnapshot> getClientePedido(String idCliente) {
    return _firestore
        .collection('users')
        .document(idCliente)
        .snapshots()
        .listen((user) {});
  }

  Stream<DocumentSnapshot> getUsersAdmin() {
    return _firestore.collection('root').document('rootUser').snapshots();
  }

  // Future<DocumentSnapshot> getClienteSpecific(String id) {
  //   return _firestore.collection('users').document(id).get();
  // }

  Future<void> setPagado(String idPedido, bool pagado) async {
    await _firestore
        .collection('historial')
        .document(idPedido)
        .updateData({'pagado': pagado});
  }

  Future<void> setHabilitado(String idProducto, bool habilitado) async {
    await _firestore
        .collection('producto')
        .document(idProducto)
        .updateData({'habilitado': habilitado});
  }

  Future<void> updateAllData(Producto producto) async {
    await _firestore
        .collection('producto')
        .document(producto.idProducto)
        .updateData({
      'descripcion': producto.descripcion,
      'habilitado': producto.habilitado,
      'nombre': producto.nombre,
      'precioUnitario': producto.precioUnitario,
      'ultimaActualizacion': Timestamp.now(),
    }).then((value) {
      producto.concreto.forEach((element) async{
           await _firestore
          .collection('producto')
          .document(producto.idProducto)
          .collection('productoConcreto')
          .document(element.idConcreto)
          .updateData({
        'cantidad': element.cantidad,
        'descripcion': element.descripcion,
        'precioTotal': element.precioTotal,
        'productoId': producto.idProducto,
      });
      });
    });
    // for (int i = 0; i < producto.concreto.length; i++) {
   
    // }
  }

  Future<void> addNewProducto(Producto newProducto) async {
    DocumentReference docRef = await _firestore.collection('producto').add({
      'nombre': newProducto.nombre,
      'descripcion': newProducto.descripcion,
      'precioUnitario': newProducto.precioUnitario,
      'habilitado': newProducto.habilitado,
      'ultimaActualizacion': Timestamp.now(),
    });
    for (int i = 0; i < newProducto.concreto.length; i++) {
      await _firestore
          .collection('producto')
          .document(docRef.documentID)
          .collection('productoConcreto')
          .document()
          .setData({
        'cantidad': newProducto.concreto[i].cantidad,
        'descripcion': newProducto.concreto[i].descripcion,
        'precioTotal': newProducto.concreto[i].precioTotal,
        'productoId': docRef.documentID,
      });
    }
  }

  Future<void> deleteProducto(String idProducto) async {
    await _firestore.collection('producto').document(idProducto).delete();
  }
}
