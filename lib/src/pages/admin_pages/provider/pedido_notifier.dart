import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/repository/firestore_provider.dart';
import 'package:kosherparatodos/src/repository/repo.dart';

class PedidoNotifier with ChangeNotifier {
  final Repository _repository = FirestoreProvider();

  List<Pedido> _pedidoList = [];
  Pedido _pedidoActual;
  UnmodifiableListView<Pedido> get pedidoList =>
      UnmodifiableListView(_pedidoList);

  PedidoNotifier.init() {
    getPedidos();
  }

  getPedidos() {
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
    bool pagado = _pedidoActual.pagado;
    try{
    _repository.setPagado(_pedidoActual.idPedido, pagado);
    _pedidoActual.pagado = pagado;
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
}
