import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kosherparatodos/src/models/categoria.dart';
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

  StreamSubscription<QuerySnapshot> getProductList() {
    return _firestore.collection('productos').snapshots().listen((event) {});
  }

  Future<void> addNewPedido(Pedido pedido, String userId) async {
    if (pedido.idPedido != null) {
      _updatePedido(pedido, userId);
    } else {
      await _firestore.collection('pedidos').add({
        'cliente': userId,
        'estado': pedido.estado,
        'fecha': Timestamp.now(),
        'pagado': false,
        'total': pedido.total,
        'productos': _addProductosToPedido(pedido.productos),
      });
    }
  }

  List<Map<String, dynamic>> _addProductosToPedido(List<Detalle> productos){
    List<Map<String, dynamic>> _list = List();
      for (int i = 0; i < productos.length; i++) {
        Detalle det = productos[i];
        _list.add(det.toFirebase());
      }
      return _list;
  }

  Future _updatePedido(
      Pedido pedido, String userId) async {
    await _firestore.collection('pedidos').document(pedido.idPedido).updateData({
      'total': pedido.total,
      'productos': _addProductosToPedido(pedido.productos),
    });
  }

  // Future<void> _removeIfWasDeleted(Pedido pedido) async{
  //   await _firestore.collection('pedidos')
  //   .document(pedido.idPedido)
  //   .collection("detalle")
  //   .getDocuments().then((doc) {
  //     for (DocumentSnapshot dsnap in doc.documents){
  //       if(pedido.productos.every((element) => element.codigo != dsnap.documentID)){
  //         dsnap.reference.delete();
  //       }
  //     }
  //   });
  // }

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

  StreamSubscription<QuerySnapshot> getPedidos() {
    return _firestore.collection('pedidos').snapshots().listen((doc) {
      doc.documents.forEach((pedido) {});
    });
  }
  StreamSubscription<DocumentSnapshot> getEstadoEntrega() {
    return _firestore.collection('estado').document('entrega').snapshots().listen((doc) {
    });
  }

  StreamSubscription<QuerySnapshot> getCategorias() {
    return _firestore.collection('categorias').snapshots().listen((doc) {
      doc.documents.forEach((categoria) {});
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

  Future<void> setPagado(String idPedido, bool pagado) async {
    await _firestore
        .collection('pedidos')
        .document(idPedido)
        .updateData({'pagado': pagado});
  }

  Future<void> setEstadoEntrega(String idPedido, String value) async {
    await _firestore
        .collection('pedidos')
        .document(idPedido)
        .updateData({'estado': value});
  }

    Future<void> setAutenticado(String idCliente, bool autenticado) async {
    await _firestore
        .collection('users')
        .document(idCliente)
        .updateData({'estaAutenticado': autenticado});
  }

  Future<void> setHabilitado(String idProducto, bool habilitado) async {
    await _firestore
        .collection('productos')
        .document(idProducto)
        .updateData({'habilitado': habilitado});
  }

  Future<void> updateAllData(Producto producto) async {
    await _firestore
        .collection('productos')
        .document(producto.productoID)
        .updateData({
      'categorias': producto.categorias,
      'codigo': producto.codigo,
      'descripcion': producto.descripcion,
      'habilitado': producto.habilitado,
      'imagen': producto.imagen,
      'precio': producto.precio,
      'stock': producto.stock,
      'unidadMedida': producto.unidadMedida,
    });
  }

  // List<Map<String, dynamic>> _addOpcionesToProducto(List<Opcion> opciones){
  //   List<Map<String, dynamic>> _list = List();
  //     for (int i = 0; i < opciones.length; i++) {
  //       Opcion det = opciones[i];
  //       _list.add(det.toFirebase());
  //     }
  //     return _list;
  // }


  Future<void> addNewProducto(Producto newProducto) async {
    await _firestore.collection('productos').add({
      'categorias': newProducto.categorias,
      'codigo': newProducto.codigo,
      'descripcion': newProducto.descripcion,
      'habilitado': newProducto.habilitado,
      'imagen': newProducto.imagen,
      'precio': newProducto.precio,
      'stock': newProducto.stock,
      'unidadMedida': newProducto.unidadMedida,
    });
  }
  
  Future<void> addNewCategoria(Categoria newCategoria) async {
    await _firestore.collection('categorias').add({
      'ancestro': newCategoria.ancestro,
      'nombre': newCategoria.nombre,
      'esPadre': newCategoria.esPadre,
    });
  }

  Future<void> deleteProducto(String idProducto) async {
    await _firestore.collection('producto').document(idProducto).delete();
  }

  Future getCategoriasPrincipal() async{
    return await _firestore.collection('categoriasMostradas').document('Zx7PmrGsLt4dGfUumgE0').get();
  }

  Future getAllCategorias() async{
    return await _firestore.collection('categorias').where('esPadre', isEqualTo: false).getDocuments();
  }

  Future getCategoriasHijos(String idPadre) async{
    return await _firestore.collection('categorias').where('ancestro', arrayContains: idPadre).getDocuments();
  }

  Future getProductosFromHijoSelected(String idHijo) async{
    return await _firestore.collection('productos').where('categorias', arrayContains: idHijo).getDocuments();
  }

}