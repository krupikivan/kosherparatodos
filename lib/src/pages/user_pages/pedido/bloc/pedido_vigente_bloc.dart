import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/pages/user_pages/historial_pedidos/bloc/bloc.dart';
import 'package:kosherparatodos/src/repository/firestore_provider.dart';
import 'package:kosherparatodos/src/repository/repo.dart';
import 'package:rxdart/rxdart.dart';

class PedidoVigenteBloc {
  // List<DetallePedido> _detalleList = []; //La lista de todos los detalles
  final Repository _repo = FirestoreProvider();
  Pedido pedido = Pedido();

//Este es el stream que maneja el detalle del pedido que voy agregando
  final _pedidoVigente = BehaviorSubject<Pedido>();
  Observable<Pedido> get getPedido => _pedidoVigente.stream;
  Function(Pedido) get addPedido => _pedidoVigente.sink.add;

//Boton +
  addingCurrentDetalle(Producto producto, int index) {
    // ItemPedido item = producto.opciones[index];
    //   if(pedido.productos == null){
    //      pedido.productos = [];
    //   }
    // if (pedido.productos.isEmpty ||
    //     !pedido.productos
    //         .any((value) => value.descripcion == item.productoID)) {
    //   Detalle nuevoDetalle = Detalle.fromOpcionSeleccionada(producto, item);
    //   pedido.productos.add(nuevoDetalle);
    //   getPedidoTotal();
    // } else {
    //   var found = pedido.productos
    //       .firstWhere((value) => value.descripcion == item.productoID);
    //   found.cantidad++;
    //   // pedido.total = found.precio * found.cantidad;
    // }
    // getPedidoTotal();
  }

  clearPedido(){
    pedido = new Pedido();
    addPedido(pedido);
  }

//Eliminar del detalle general
  removeOnPedido(Detalle det) {
    pedido.productos.removeWhere(
        (item) => item.descripcion == det.descripcion);
        getPedidoTotal();
  }

  // _addDetalleToPedido(List<DetallePedido> list){
  //   pedido.detallePedido = list;
  //   addDetalle(pedido);
  // }

    addingPedidoForEdit(pedidoEdit){
    pedido = pedidoEdit;
    addPedido(pedido);
  }

//Boton -
  removeDetalle(Producto producto, int index) {
    // ItemPedido opc = producto.opciones[index];
    // if (pedido.productos
    //     .any((value) => value.descripcion == opc.productoID)) {
    //   var found = pedido.productos
    //       .firstWhere((value) => value.descripcion == opc.productoID);
    //   found.cantidad--;
    //   // found.precioDetalle -= producto.opciones[index].precioTotal;
    //   if (found.cantidad == 0)
    //     pedido.productos
    //         .removeWhere((value) => value.descripcion == opc.productoID);
    // }
    // getPedidoTotal();
  }

  getPedidoTotal() {
    pedido.total = 0;
    pedido.productos.forEach((item) => pedido.total += item.precio * item.cantidad);
    addPedido(pedido);
  }

  savePedido() {
    try {
      _repo.addNewPedido(pedido, blocUserData.getUserId())
      .whenComplete(() => clearPedido());
    } catch (e) {}
  }

  void dispose() async {
    await _pedidoVigente.drain();
    _pedidoVigente.close();
  }
}

final blocPedidoVigente = PedidoVigenteBloc();
