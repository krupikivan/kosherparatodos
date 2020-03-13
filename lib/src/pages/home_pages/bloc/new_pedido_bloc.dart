import 'package:kosherparatodos/src/models/detalle_pedido.dart';

import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/models/product.dart';
import 'package:rxdart/rxdart.dart';

class NewPedidoBloc {

//Este es el stream que va manejando todos los detalles
  final _docPedidoCart = BehaviorSubject<List<DetallePedido>>();
  Observable<List<DetallePedido>> get getFromPedido => _docPedidoCart.stream;
  Function(List<DetallePedido>) get addToPedido => _docPedidoCart.sink.add;

//Este es el stream que va esuchando el numero del dropdown para luego agregarlo al detalle
  final _cantidad = BehaviorSubject<int>();
  Observable<int> get getCantidad => _cantidad.stream;
  Function(int) get addCantidad => _cantidad.sink.add;

//Este es el stream que va guardando el detalles del pedido vigente
  // final _docNewDetallePedido = BehaviorSubject<DetallePedido>();
  // Observable<DetallePedido> get getDetallePedido => _docNewDetallePedido.stream;
  // Function(DetallePedido) get addDetallePedido => _docNewDetallePedido.sink.add;


//Este es el stream que va a guardar en el historial de pedidos una vez finalizado
  final _docNewPedido = BehaviorSubject<Pedido>();
  Observable<Pedido> get getPedido => _docNewPedido.stream;
  Function(Pedido) get addPedido => _docNewPedido.sink.add;

  // addCantidadSeleccionada(int value){
  //   getDetallePedido.listen((detalle) {
  //     DetallePedido det = detalle;
  //     detalle.cantidad = value;
  //     addDetallePedido(det);
  //   });
  // }

  onNewDetalle(Producto producto) async{
    var cant = await getCantidad.last;
    // getCantidad.listen((cant) {
      getFromPedido.listen((detalle){
        DetallePedido det = DetallePedido();
        det.cantidad = cant;
        det.name = producto.name;
        det.unidad = producto.unidadMedida;
        detalle.add(det);
        addToPedido(detalle);
      });
    // });
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
