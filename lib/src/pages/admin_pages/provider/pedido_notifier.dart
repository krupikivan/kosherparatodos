import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/repository/firestore_provider.dart';
import 'package:kosherparatodos/src/repository/repo.dart';

class PedidoNotifier with ChangeNotifier {
  final Repository _repository = FirestoreProvider();

  List _estadoEntrega = [];

  List<Pedido> _pedidoList = [];
  Pedido _pedidoActual;
  UnmodifiableListView<Pedido> get pedidoList =>
      UnmodifiableListView(_pedidoList);

  PedidoNotifier.init() {
    getPedidos();
  }

  getPedidos() {
    _getEstadosEntrega();
    List<Pedido> _list = [];
    _repository.getPedidos().onData((listPed) {
      listPed.documents.forEach((pedido) {

        // _repository.getClientePedido(pedido.data['cliente']['clienteID']).onData((cliente) {
          Pedido _pedido =
              Pedido.fromPedidos(pedido.data, pedido.documentID);
          _list.add(_pedido);
          _pedidoList = _list;
          notifyListeners();
        // });

      });
    });
  }

  _getEstadosEntrega(){
    _repository.getEstadoEntrega().onData((data) {
      EstadoEntrega _ee = EstadoEntrega.fromMap(data['estado']);
      _estadoEntrega = _ee.entrega;
      notifyListeners();
     });
  }

  // getDetallePedido() {
  //   List<DetallePedido> _list = [];
  //   _repository.getDetallePedidoActual(_pedidoActual.idPedido).onData((detalleList) {
  //     detalleList.documents.forEach((detalle) {
  //     DetallePedido detallePedido =
  //             DetallePedido.fromMap(detalle.data);
  //         _list.add(detallePedido);
  //         _pedidoActual.detallePedido = _list;
  //         notifyListeners();
  //     });
  //   });
  // }

  setPagado(){
    bool pagado = _pedidoActual.pagado == false ? true : false;
    try{
    _repository.setPagado(_pedidoActual.idPedido, pagado);
    _pedidoActual.pagado = pagado;
    getPedidos();
    }catch(e){}
  }

  setEstadoEntrega(value){
    try{
    _repository.setEstadoEntrega(_pedidoActual.idPedido, value);
    _pedidoActual.estado = value;
    getPedidos();
    }catch(e){}
  }

  // getPedidos() async {
  //   List<Pedido> _list = [];
  //   Cliente cliente;

  //   await _repository.getPedidos().then((snapshot) async{
  //     snapshot.documents.forEach((documents) async{

  //       await _repository.getClienteSpecific(documents.data['cliente']).then((doc){
  //         cliente = Cliente.fromMap(doc.data);
  //       });

  //       Pedido pedido = Pedido.fromMap(documents.data, documents.documentID, cliente);
  //       _list.add(pedido);
  //     });
  //   }).whenComplete(() {
  //    _pedidoList = _list;
  //    notifyListeners();
  //   });
  // }

  Pedido get pedidoActual => _pedidoActual;

  set pedidoList(List<Pedido> pedidoList) {
    _pedidoList = pedidoList;
    notifyListeners();
  }

  set pedidoActual(Pedido pedidoActual) {
    _pedidoActual = pedidoActual;
    notifyListeners();
  }
  
    UnmodifiableListView get getEstadoEntrega =>
      UnmodifiableListView(_estadoEntrega);

}
