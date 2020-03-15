import 'package:kosherparatodos/src/models/detalle_pedido.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/models/product.dart';
import 'package:rxdart/rxdart.dart';

class NewPedidoBloc {
  List<DetallePedido> _detalleList = []; //La lista de todos los detalles
  List<DetallePedido> _currentDetalle = []; //La lista del detalle por tipo de producto
  Pedido pedido = Pedido();

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

//Este es el stream que maneja el detalle del pedido que voy agregando
  final _detallePedido = BehaviorSubject<List<DetallePedido>>();
  Observable<List<DetallePedido>> get getDetalle => _detallePedido.stream;
  Function(List<DetallePedido>) get addDetalle => _detallePedido.sink.add;

  onNewDetalle(Producto producto) {
        for(int i=0; i<_currentDetalle.length; i++){
            DetallePedido det = DetallePedido();
            det.bulto = _currentDetalle[i].bulto;
            det.unidadMedida = _currentDetalle[i].unidadMedida;
            det.tipo = _currentDetalle[i].tipo;
            det.cantidad = _currentDetalle[i].cantidad;
            det.nombre = producto.nombre;
            det.unidades = _currentDetalle[i].unidades;
            det.precioUnitario = producto.precioUnitario * det.cantidad;
            det.precioTotal = det.precioUnitario * det.unidades;
            _detalleList.add(det);
        }
        _currentDetalle.clear();
        addDetalleList(_detalleList);
        pedido.detallePedido = _detalleList;
        pedido.total = _getPedidoTotal();
        addPedido(pedido);
  }

  addingCurrentDetalle(Producto producto, int index) {
    bool added = false;
    for (int i = 0; i < _currentDetalle.length; i++) {
      if (_currentDetalle[i].cantidad == producto.opcionCantidad[index]) {
            _currentDetalle[i].unidades += 1;   
             added = true;
      }
    }
    added == false ? _addNewOnSearching(producto, index) : added = false;
    addDetalle(_currentDetalle);
  }

  _addNewOnSearching(Producto producto, index) {
    // if(_detalleList.firstWhere((item) {
    //   item.tipo.contains(producto.tipo);
    // } ))
    {
      DetallePedido det = DetallePedido();
      det.nombre = producto.nombre;
      det.cantidad = producto.opcionCantidad[index];
      det.tipo = producto.tipo;
      det.unidadMedida = producto.unidadMedida;
      det.bulto = producto.bulto;
      det.precioUnitario = producto.precioUnitario * det.cantidad;
      det.unidades = 1;
      _currentDetalle.add(det);
    }
  }

  removeOnPedido(DetallePedido det){
    _detalleList.removeWhere((item) => item.tipo == det.tipo && item.precioTotal == det.precioTotal);
    addDetalleList(_detalleList);
    pedido.total = _getPedidoTotal();
    addPedido(pedido);
  }

  removeCurrentDetalle(Producto producto, int index) {
    for (int i = 0; i < _currentDetalle.length; i++) {
      if (_currentDetalle[i].cantidad == producto.opcionCantidad[index]) {
        _currentDetalle[i].unidades > 1
            ? _currentDetalle[i].unidades -= 1
            : _currentDetalle.removeAt(i);
      }
    }
    addDetalle(_currentDetalle);
  }

  _getPedidoTotal() {
    double _total = 0;
    _detalleList.forEach(
      (item) => _total += item.precioTotal);
    // for (int i = 0; i < _currentDetalle.length; i++) {
    //   _total += _list[i].total;
    // }
    return _total;
  }

  void dispose() async {
    await _docPedidoCart.drain();
    _docPedidoCart.close();
    await _docNewPedido.drain();
    _docNewPedido.close();
    _docPedidoCart.close();
    await _detallePedido.drain();
    _detallePedido.close();
    await _cantidad.drain();
    _cantidad.close();
  }
}

final blocNewPedido = NewPedidoBloc();
