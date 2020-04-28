import 'package:kosherparatodos/src/models/detalle_pedido.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/models/producto_concreto.dart';
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
    ProductoConcreto pc = producto.concreto[index];
      if(pedido.detallePedido == null){
         pedido.detallePedido = [];
      }
    if (pedido.detallePedido.isEmpty ||
        !pedido.detallePedido
            .any((value) => value.concreto.idConcreto == pc.idConcreto)) {
      DetallePedido nuevoDetalle = DetallePedido.fromAddingNew(pc);
      pedido.detallePedido.add(nuevoDetalle);
      getPedidoTotal();
    } else {
      var found = pedido.detallePedido
          .firstWhere((value) => value.concreto.idConcreto == pc.idConcreto);
      found.cantidad++;
      found.precioDetalle = found.precioUnitario * found.cantidad;
    }
    getPedidoTotal();
  }

  clearPedido(){
    pedido = new Pedido();
    addPedido(pedido);
  }

//Eliminar del detalle general
  removeOnPedido(DetallePedido det) {
    pedido.detallePedido.removeWhere(
        (item) => item.concreto.idConcreto == det.concreto.idConcreto);
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
    ProductoConcreto pc = producto.concreto[index];
    if (pedido.detallePedido
        .any((value) => value.concreto.idConcreto == pc.idConcreto)) {
      var found = pedido.detallePedido
          .firstWhere((value) => value.concreto.idConcreto == pc.idConcreto);
      found.cantidad--;
      found.precioDetalle -= producto.concreto[index].precioTotal;
      if (found.cantidad == 0)
        pedido.detallePedido
            .removeWhere((value) => value.concreto.idConcreto == pc.idConcreto);
    }
    getPedidoTotal();
  }

  getPedidoTotal() {
    pedido.total = 0;
    pedido.detallePedido.forEach((item) => pedido.total += item.precioDetalle);
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
