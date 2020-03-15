import 'package:kosherparatodos/src/models/detalle_pedido.dart';

import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/models/product.dart';
import 'package:rxdart/rxdart.dart';

class NewPedidoBloc {

List<DetallePedido> _detalleList = [];

//Este es el stream que va manejando todos los detalles
  final _docPedidoCart = BehaviorSubject<List<DetallePedido>>();
  Observable<List<DetallePedido>> get getDetalleList => _docPedidoCart.stream;
  Function(List<DetallePedido>) get addDetalleList => _docPedidoCart.sink.add;

//Este es el stream que va esuchando el numero del dropdown para luego agregarlo al detalle
  final _cantidad = BehaviorSubject<int>();
  Observable<int> get getCantidad => _cantidad.stream;
  Function(int) get addCantidad => _cantidad.sink.add;

//Este es el stream que va a guardar en el historial de pedidos una vez finalizado
  final _docNewPedido = BehaviorSubject<Pedido>();
  Observable<Pedido> get getPedido => _docNewPedido.stream;
  Function(Pedido) get addPedido => _docNewPedido.sink.add;

  onNewDetalle(Producto producto, int cantidad) async{
        Pedido pedido = Pedido();
        DetallePedido det = DetallePedido();
        det.cantidad = cantidad;
        det.name = producto.name;
        det.unidad = producto.unidadMedida;
        det.total = producto.costo.toDouble() * cantidad;
        _detalleList.add(det);
        addDetalleList(_detalleList);
        pedido.detallePedido = _detalleList;
        pedido.total = _getPedidoTotal(_detalleList);
        addPedido(pedido);
  }

  _getPedidoTotal(List<DetallePedido> _list){
    double _total = 0;
    for(int i=0; i<_list.length; i++){
      _total += _list[i].total;
    }
    return _total;
  }

  void dispose() async {
    await _docPedidoCart.drain();
    _docPedidoCart.close();
        await _docNewPedido.drain();
    _docNewPedido.close();
    _docPedidoCart.close();
    //     await _docNewDetallePedido.drain();
    // _docNewDetallePedido.close();
        await _cantidad.drain();
    _cantidad.close();
  }
}

final blocNewPedido = NewPedidoBloc();
