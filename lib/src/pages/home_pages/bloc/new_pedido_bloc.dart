import 'package:kosherparatodos/src/models/detalle_pedido.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/models/producto_concreto.dart';
import 'package:rxdart/rxdart.dart';

class NewPedidoBloc {
  List<DetallePedido> _detalleList = []; //La lista de todos los detalles

  Pedido pedido = Pedido();


//Este es el stream que va a guardar en el historial de pedidos una vez finalizado
  final _docNewPedido = BehaviorSubject<Pedido>();
  Observable<Pedido> get getPedido => _docNewPedido.stream;
  Function(Pedido) get addPedido => _docNewPedido.sink.add;

//Este es el stream que maneja el detalle del pedido que voy agregando
  final _detallePedido = BehaviorSubject<List<DetallePedido>>();
  Observable<List<DetallePedido>> get getDetalle => _detallePedido.stream;
  Function(List<DetallePedido>) get addDetalle => _detallePedido.sink.add;

//Boton +
  addingCurrentDetalle(Producto producto, int index) {
    ProductoConcreto pc = producto.concreto[index];
    if(_detalleList.isEmpty || !_detalleList.any((value)=> value.concreto.idConcreto == pc.idConcreto)){
      pedido = new Pedido();
            DetallePedido nuevoDetalle = DetallePedido();
            nuevoDetalle.concreto = pc;
            nuevoDetalle.cantidad = 1;
            nuevoDetalle.precioDetalle = pc.precioTotal * nuevoDetalle.cantidad;
            _detalleList.add(nuevoDetalle);
    }else{
      var found = _detalleList.firstWhere((value) => value.concreto.idConcreto == pc.idConcreto);
      found.cantidad ++;
      found.precioDetalle = pc.precioTotal * found.cantidad;
    }
    addDetalle(_detalleList);
    actualizarPedidotTotal();
  }

//Eliminar del detalle general
  removeOnPedido(DetallePedido det) {
    _detalleList.removeWhere((item) =>
        item.concreto.idConcreto == det.concreto.idConcreto);
    actualizarPedidotTotal();
    addDetalle(_detalleList);
    addPedido(pedido);
  }

//Boton -
  removeDetalle(Producto producto, int index) {
    ProductoConcreto pc = producto.concreto[index];
    if(_detalleList.any((value)=> value.concreto.idConcreto == pc.idConcreto)){
      var found = _detalleList.firstWhere((value) => value.concreto.idConcreto == pc.idConcreto);
      found.cantidad --;
      found.precioDetalle -= producto.concreto[index].precioTotal;
      if(found.cantidad == 0)
      _detalleList.removeWhere((value)=> value.concreto.idConcreto == pc.idConcreto);
    }
    actualizarPedidotTotal();
    addDetalle(_detalleList);
  }

  actualizarPedidotTotal(){
    double _total = 0;
    // DetallePedido det = _detalleList.isNotEmpty ? _detalleList.firstWhere((item) => item.concreto.id == pc.id) : null;
    // suma == true && det !=null ? pedido.total += det.precioDetalle : det !=null ?  pedido.total -= det.precioDetalle : det = null;
    _detalleList.forEach((item) => _total += item.precioDetalle);
    // pedido.total = _total;
    pedido.detallePedido = _detalleList;
    pedido.total = _total;
    addPedido(pedido);
  }

  getPedidoTotal() {
    double _total = 0;
    _detalleList.forEach((item) => _total += item.precioDetalle);
    // for (int i = 0; i < _currentDetalle.length; i++) {
    //   _total += _list[i].total;
    // }
    return _total;
  }

  void dispose() async {
    await _docNewPedido.drain();
    _docNewPedido.close();
    await _detallePedido.drain();
    _detallePedido.close();
  }
}

final blocNewPedido = NewPedidoBloc();
