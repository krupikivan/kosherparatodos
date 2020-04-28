import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kosherparatodos/src/models/detalle_pedido.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/models/producto.dart';
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

  StreamSubscription<QuerySnapshot> getPedido(String userUID) {
    return _firestore
        .collection('pedidos')
        .where('cliente', isEqualTo: userUID)
        .snapshots()
        .listen((event) {});
  }

  Future<QuerySnapshot> getDetallePedido(String pedidoID) {
    return _firestore
        .collection('pedidos')
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

  Future<void> addNewPedido(Pedido pedido, String userId) async {
    if (pedido.idPedido != null) {
      _updatePedido(pedido, userId);
    } else {
      DocumentReference docRef = await _firestore.collection('pedidos').add({
        'cliente': userId,
        'estado': Pedido().getEstadoString(Estado.ENPROCESO),
        'fecha': Timestamp.now(),
        'pagado': false,
        'total': pedido.total,
      });
      for (int i = 0; i < pedido.detallePedido.length; i++) {
        await _firestore
            .collection('pedidos')
            .document(docRef.documentID)
            .collection('detalle')
            .document()
            .setData({
          'cantidad': pedido.detallePedido[i].cantidad,
          'descripcion': pedido.detallePedido[i].concreto.descripcion,
          'idConcreto': pedido.detallePedido[i].concreto.idConcreto,
          'idProducto': pedido.detallePedido[i].concreto.idProducto,
          'precioDetalle': pedido.detallePedido[i].precioDetalle,
          'precioUnitario': pedido.detallePedido[i].concreto.precioTotal,
        });
      }
    }
  }

  Future _updatePedido(
      Pedido pedido, String userId) async {
    await _firestore.collection('pedidos').document(pedido.idPedido).updateData({
      'total': pedido.total,
    }).then((value) {
      _removeIfWasDeleted(pedido).whenComplete(() {

              pedido.detallePedido.forEach((detallePedido) async{ 
         await _firestore
            .collection('pedidos')
            .document(pedido.idPedido)
            .collection('detalle')
            .document(detallePedido.idDetallePedido)
            .setData({
          'cantidad': detallePedido.cantidad,
          'descripcion': detallePedido.descripcion,
          'idConcreto': detallePedido.concreto.idConcreto,
          'idProducto': detallePedido.concreto.idProducto,
          'precioDetalle': detallePedido.precioDetalle,
          'precioUnitario': detallePedido.precioUnitario,
        });
      });

      });
    });
  }

  Future<void> _removeIfWasDeleted(Pedido pedido) async{
    await _firestore.collection('pedidos')
    .document(pedido.idPedido)
    .collection("detalle")
    .getDocuments().then((doc) {
      for (DocumentSnapshot dsnap in doc.documents){
        if(pedido.detallePedido.every((element) => element.idDetallePedido != dsnap.documentID)){
          dsnap.reference.delete();
        }
      }
    });
  }

  Future<void> deletePedido(String idPedido) async{
      await _firestore.collection('pedidos')
    .document(idPedido)
    .delete();
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
  //   return _firestore.collection('pedidos').getDocuments();
  // }

  StreamSubscription<QuerySnapshot> getPedidos() {
    return _firestore.collection('pedidos').snapshots().listen((doc) {
      doc.documents.forEach((pedido) {});
    });
  }

  StreamSubscription<QuerySnapshot> getDetallePedidoActual(String idPedido) {
    return _firestore
        .collection('pedidos')
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
        .collection('pedidos')
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
      producto.concreto.forEach((element) async {
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
