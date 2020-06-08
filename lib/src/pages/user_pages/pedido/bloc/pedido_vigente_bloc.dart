import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/pages/user_pages/historial_pedidos/bloc/bloc.dart';
import 'package:kosherparatodos/src/repository/firestore_provider.dart';
import 'package:kosherparatodos/src/repository/repo.dart';
import 'package:rxdart/rxdart.dart';

class PedidoVigenteBloc {
  final Repository _repo = FirestoreProvider();
  Pedido pedido = Pedido();

//Este es el stream que maneja el detalle del pedido que voy agregando
  final _pedidoVigente = BehaviorSubject<Pedido>();
  Observable<Pedido> get getPedido => _pedidoVigente.stream;
  Function(Pedido) get addPedido => _pedidoVigente.sink.add;

//  Actualizando el carrito de compra
  void updateCarrito(Producto producto, int cantidad, int stockActual) {
    final Detalle detalle =
        Detalle.fromUpdateCarrito(producto, cantidad, stockActual);
    //    if (pedido.productos == null) {
    //   pedido.productos = [];
    // }
    pedido.productos ??= [];
    if (pedido.productos.isEmpty ||
        !pedido.productos
            .any((value) => value.productoID == detalle.productoID)) {
      pedido.productos.add(detalle);
      getPedidoTotal();
    } else {
      final found = pedido.productos
          .firstWhere((value) => value.productoID == detalle.productoID);
      found.cantidad = cantidad;
    }
    getPedidoTotal();
  }

//  Seteamos el pedido vigente a un pedido vacio
  clearPedido() {
    pedido = Pedido();
    addPedido(pedido);
  }

//  Eliminar del detalle general
  void removeOnPedido(Detalle det) {
    pedido.productos.removeWhere((item) => item.productoID == det.productoID);
    getPedidoTotal();
  }

//  Cuando editamos pedido lo cargamos en el carrito
  void agregarPedidoParaEditar(Pedido pedidoEdit) {
    pedido = pedidoEdit;
    addPedido(pedido);
  }

//  Actualiza el total del pedido vigente
  void getPedidoTotal() {
    pedido.total = 0;
    pedido.productos
        .forEach((item) => pedido.total += item.precio * item.cantidad);
    if (pedido.total == 0) {
      final Pedido ped = Pedido();
      addPedido(ped);
    } else {
      addPedido(pedido);
    }
  }

//  Realiza el pedido y lo guarda en Firebase
  Future realizarPedido() async {
    await _repo.addNewPedido(pedido, blocUserData.getClienteLogeado()).then(
        (value) => true,
        onError: (onError) => _handlingError('No hay stock -Pedido Vigente-'));
    // .catchError(() => _handlingError('Error on Catch error'))
    // .whenComplete(() => clearPedido());
  }

  _handlingError(String msg) {
    throw Exception(msg);
  }

  void dispose() async {
    await _pedidoVigente.drain();
    _pedidoVigente.close();
  }
}

final PedidoVigenteBloc blocPedidoVigente = PedidoVigenteBloc();
