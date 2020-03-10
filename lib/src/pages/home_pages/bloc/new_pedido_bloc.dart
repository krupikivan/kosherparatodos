import 'package:kosherparatodos/src/models/detalle_pedido.dart';
import 'package:rxdart/rxdart.dart';

class NewPedidoBloc {

  List<DetallePedido> _list = [];

  final _docPedidoCart = BehaviorSubject<List<DetallePedido>>();
  Observable<List<DetallePedido>> get getFromPedido => _docPedidoCart.stream;
  Function(List<DetallePedido>) get addToPedido => _docPedidoCart.sink.add;

  final _docNewPedido = BehaviorSubject<DetallePedido>();
  Observable<DetallePedido> get getPedido => _docNewPedido.stream;
  Function(DetallePedido) get addPedido => _docNewPedido.sink.add;

  addCantidadSeleccionada(int value){
    getPedido.listen((detalle) {
      DetallePedido det = detalle;
      detalle.cantidad = value;
      addPedido(det);
    });
  }

  onNewProduct(){
    getPedido.listen((detalle) {
      _list.add(detalle);
      addToPedido(_list);
    });
  }

  void dispose() async {
    await _docPedidoCart.drain();
    _docPedidoCart.close();
        await _docNewPedido.drain();
    _docNewPedido.close();
  }
}

final blocNewPedido = NewPedidoBloc();
