import 'package:kosherparatodos/src/models/detalle_pedido.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:rxdart/rxdart.dart';

class NewPedidoBloc {

  List<DetallePedido> _list = [];

  final _docPedidoCart = BehaviorSubject<List<DetallePedido>>();
  Observable<List<DetallePedido>> get getFromPedido => _docPedidoCart.stream;
  Function(List<DetallePedido>) get addToPedido => _docPedidoCart.sink.add;

  final _docNewDetallePedido = BehaviorSubject<DetallePedido>();
  Observable<DetallePedido> get getDetallePedido => _docNewDetallePedido.stream;
  Function(DetallePedido) get addDetallePedido => _docNewDetallePedido.sink.add;

  final _docNewPedido = BehaviorSubject<Pedido>();
  Observable<Pedido> get getPedido => _docNewPedido.stream;
  Function(Pedido) get addPedido => _docNewPedido.sink.add;

  addCantidadSeleccionada(int value){
    getDetallePedido.listen((detalle) {
      DetallePedido det = detalle;
      detalle.cantidad = value;
      addDetallePedido(det);
    });
  }

  onNewDetalle(){
    getDetallePedido.listen((detalle) {
      _list.add(detalle);
      addToPedido(_list);
    });
  }

  void dispose() async {
    await _docPedidoCart.drain();
    _docPedidoCart.close();
        await _docNewPedido.drain();
    _docNewPedido.close();
    _docPedidoCart.close();
        await _docNewDetallePedido.drain();
    _docNewDetallePedido.close();
  }
}

final blocNewPedido = NewPedidoBloc();
