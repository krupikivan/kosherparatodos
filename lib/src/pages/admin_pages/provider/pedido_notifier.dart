import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:kosherparatodos/src/models/cliente.dart';
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

  getPedidos() async {
    List<Pedido> _list = [];
    Cliente cliente;
    await _repository.getPedidos().then((snapshot) async{
      snapshot.documents.forEach((documents) async{
///TODO: Ver de traer todo junto en un solo metodo o con CF
        await _repository.getClienteSpecific(documents.data['cliente']).then((doc){
          cliente = Cliente.fromMap(doc.data);
        });
        
        Pedido pedido = Pedido.fromMap(documents.data, documents.documentID, cliente);
        _list.add(pedido);

      });
    }).whenComplete(() {
     _pedidoList = _list;
     notifyListeners();
    });  
  }

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
