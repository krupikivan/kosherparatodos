import 'package:kosherparatodos/src/models/detalle_pedido.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
// import 'package:kosherparatodos/src/repository/repo.dart';
import 'package:rxdart/rxdart.dart';

class NewPedidoBloc {
  // final _repository = Repository();

  final _docPedidoCart = BehaviorSubject<List<DetallePedido>>();
  Observable<List<DetallePedido>> get getItems => _docPedidoCart.stream;
  Function(List<DetallePedido>) get addItems => _docPedidoCart.sink.add;

  final _docNewPedido = BehaviorSubject<Pedido>();
  Observable<Pedido> get getPedido => _docNewPedido.stream;
  Function(Pedido) get addPedido => _docNewPedido.sink.add;


  void dispose() async {
    await _docPedidoCart.drain();
    _docPedidoCart.close();
        await _docNewPedido.drain();
    _docNewPedido.close();
  }
}

final blocNewPedido = NewPedidoBloc();
