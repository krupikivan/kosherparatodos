import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kosherparatodos/src/models/categoria.dart';
import 'package:kosherparatodos/src/models/cliente.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/repository/repo.dart';
import 'package:kosherparatodos/src/utils/converter.dart';

class FirestoreProvider implements Repository {
  final Firestore _firestore = Firestore.instance;

//----------------------------------------------------SE FIJA SI EL USUARIO ES ADMIN
  @override
  Future<bool> getUserAdmin(String id) {
    return _firestore
        .collection('root')
        .document('rootUser')
        .get()
        .then((DocumentSnapshot value) {
      final int length = value.data['userID'].length as int;
      for (int i = 0; i < length; i++) {
        if (value.data['userID'][i] == id) {
          return true;
        }
      }
      return false;
    });
  }

  ///----------------------------------------------------------
  ///------------------------USER------------------------------
  ///----------------------------------------------------------

  @override
  Future<QuerySnapshot> isAuthenticated(String email) {
    return _firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .getDocuments();
  }

//----------------------------------------------------TRAE LOS DATOS DEL CLIENTE LOGEADO
  @override
  Stream<DocumentSnapshot> getUserData(String userUID) {
    return _firestore.collection('users').document(userUID).snapshots();
  }

//----------------------------------------------------TRAE LOS PEDIDOS DEL CLIENTE LOGEADO
  @override
  Future<QuerySnapshot> getPedidosCliente(String clienteID) async {
    return _firestore
        .collection('pedidos')
        .where('cliente.clienteID', isEqualTo: clienteID)
        .orderBy('fecha', descending: true)
        .getDocuments();
  }

//----------------------------------------------------TRAE LOS PRODUCTOS HABILITADOS PARA EL CLIENTE
  @override
  Future<QuerySnapshot> getProductosHabilitados() async {
    return _firestore
        .collection('productos')
        .where('habilitado', isEqualTo: true)
        .getDocuments();
  }

//----------------------------------------------------CREA UN NUEVO PEDIDO DEL CLIENTE
  @override
  Future<void> addNewPedido(Pedido pedido, Cliente cliente) async {
    if (pedido.pedidoID != null) {
      _updatePedido(pedido, cliente.clienteID);
    } else {
      final Map<String, String> nombreMap = {
        'nombre': cliente.nombre.nombre,
        'apellido': cliente.nombre.apellido
      };
      final Map<String, dynamic> clienteMap = {
        'clienteID': cliente.clienteID,
        'nombre': nombreMap,
      };
      await _firestore.runTransaction((t) async {
        for (var i = 0; i < pedido.productos.length; i++) {
          final int cant = pedido.productos[i].cantidad as int;
          final int stk = pedido.productos[i].stockActual as int;
          if (cant > stk) {
            throw Exception('No hay stock disponible');
          }
          await _firestore
              .collection('productos')
              .document(pedido.productos[i].productoID)
              .updateData({
            'stock':
                pedido.productos[i].stockActual - pedido.productos[i].cantidad
          });
        }
        await _firestore.collection('pedidos').add({
          'cliente': clienteMap,
          'fecha': Timestamp.now(),
          'pagado': false,
          'estado': 'En Preparacion',
          'total': pedido.total,
          'productos': _addProductosToPedido(pedido.productos),
        });
      });
    }
  }

//----------------------------------------------------ACTUALIZA EL PEDIDO SI YA EXISTE
  Future _updatePedido(Pedido pedido, String userId) async {
    await _firestore
        .collection('pedidos')
        .document(pedido.pedidoID)
        .updateData({
      'total': pedido.total,
      'estado': Pedido.enumEntregaToString(pedido.estadoEntrega),
      'productos': _addProductosToPedido(pedido.productos),
    });
  }

  List<Map<String, dynamic>> _addProductosToPedido(List productos) {
    final List<Map<String, dynamic>> _list = [];
    for (int i = 0; i < productos.length; i++) {
      final det = productos[i];
      _list.add(det.toFirebase());
    }
    return _list;
  }

//----------------------------------------------------ELIMINAR PEDIDO DEL CLIENTE LOGUEADO
  @override
  Future<void> eliminarPedido(Pedido pedidoSelected) async {
    _firestore.runTransaction((t) async {
      // pedidoSelected.productos.forEach((Detalle element) async {
      //   final DocumentSnapshot doc = await _firestore
      //       .collection('productos')
      //       .document(element.productoID)
      //       .get();
      //   await _firestore
      //       .collection('productos')
      //       .document(element.productoID)
      //       .updateData({'stock': doc.data['stock'] - element.cantidad});
      // });

      for (var i = 0; i < pedidoSelected.productos.length; i++) {
        final DocumentSnapshot doc = await _firestore
            .collection('productos')
            .document(pedidoSelected.productos[i].productoID)
            .get();
        await _firestore
            .collection('productos')
            .document(pedidoSelected.productos[i].productoID)
            .updateData({
          'stock': doc.data['stock'] + pedidoSelected.productos[i].cantidad
        });
      }
      await _firestore
          .collection('pedidos')
          .document(pedidoSelected.pedidoID)
          .delete();
    });
  }

  ///-----------------------------------------------------------
  ///------------------------ADMIN------------------------------
  ///-----------------------------------------------------------

//----------------------------------------------------DEUELVE TODOS LOS CLIENTES
  @override
  Future<QuerySnapshot> getClientes() {
    return _firestore.collection('users').getDocuments();
  }

//----------------------------------------------------DEVUELVE TODOS LOS PEDIDOS
  @override
  StreamSubscription<QuerySnapshot> getAllPedidos() {
    return _firestore.collection('pedidos').snapshots().listen((doc) {
      doc.documents.forEach((pedido) {});
    });
  }

  @override
  Future<DocumentSnapshot> getEstadoEntrega() {
    return _firestore.collection('estado').document('entrega').get();
  }

  @override
  StreamSubscription<QuerySnapshot> getCategorias() {
    return _firestore.collection('categorias').snapshots().listen((doc) {
      doc.documents.forEach((categoria) {});
    });
  }

  @override
  StreamSubscription<DocumentSnapshot> getClientePedido(String idCliente) {
    return _firestore
        .collection('users')
        .document(idCliente)
        .snapshots()
        .listen((user) {});
  }

  @override
  Stream<DocumentSnapshot> getUsersAdmin() {
    return _firestore.collection('root').document('rootUser').snapshots();
  }

  @override
  Future<void> setPagado(String idPedido, {bool pagado}) async {
    await _firestore
        .collection('pedidos')
        .document(idPedido)
        .updateData({'pagado': pagado});
  }

  @override
  Future<void> setEstadoEntrega(String idPedido, EnumEntrega value) async {
    await _firestore
        .collection('pedidos')
        .document(idPedido)
        .updateData({'estado': Pedido.enumEntregaToString(value)});
  }

  @override
  Future<void> setAutenticado(String idCliente, {bool autenticado}) async {
    await _firestore
        .collection('users')
        .document(idCliente)
        .updateData({'estaAutenticado': autenticado});
  }

  @override
  Future<void> setHabilitado(String idProducto, {bool habilitado}) async {
    await _firestore
        .collection('productos')
        .document(idProducto)
        .updateData({'habilitado': habilitado});
  }

  @override
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

  @override
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

  @override
  Future<void> addNewCategoria(Categoria newCategoria) async {
    final DocumentReference docRef = _firestore
        .collection('categoriasMostradas')
        .document('Zx7PmrGsLt4dGfUumgE0');

    await _firestore.runTransaction((t) async {
      await _firestore.collection('categorias').add({
        'ancestro': newCategoria.ancestro,
        'nombre': newCategoria.nombre,
        'esPadre': newCategoria.esPadre,
      }).then((value) {
        final Map<String, String> body = {
          'id': value.documentID,
          'nombre': newCategoria.nombre
        };
        docRef.updateData({
          'categorias': FieldValue.arrayUnion([body])
        });
      });
    }).catchError((onError) => print(onError.toString()));
  }

  @override
  Future<void> deleteProducto(String idProducto) async {
    await _firestore.collection('producto').document(idProducto).delete();
  }

  @override
  Future<DocumentSnapshot> getCategoriasPrincipal() async {
    return _firestore
        .collection('categoriasMostradas')
        .document('Zx7PmrGsLt4dGfUumgE0')
        .get();
  }

  @override
  Future<QuerySnapshot> getAllCategorias() async {
    return _firestore.collection('categorias').getDocuments();
  }

  @override
  Future<QuerySnapshot> getCategoriasHijos(String idPadre) async {
    return _firestore
        .collection('categorias')
        .where('ancestro', arrayContains: idPadre)
        .getDocuments();
  }

  @override
  Future<QuerySnapshot> getProductosFromHijoSelected(String idHijo) async {
    return _firestore
        .collection('productos')
        .where('categorias', arrayContains: idHijo)
        .getDocuments();
  }
}
