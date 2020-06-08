import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:kosherparatodos/src/models/cliente.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/pedido_notifier.dart';
import 'package:kosherparatodos/src/repository/firestore_provider.dart';
import 'package:kosherparatodos/src/repository/repo.dart';

class ClienteNotifier with ChangeNotifier {
  final Repository _repository = FirestoreProvider();

  List<Cliente> _clienteList = [];
  Cliente _clienteActual;

  UnmodifiableListView<Cliente> get clienteList =>
      UnmodifiableListView(_clienteList);

  ClienteNotifier.init() {
    getClientes();
  }

//  Trae todos los clientes
  void getClientes() async {
    final List<Cliente> _list = [];
    await _repository.getClientes().then((snapshot) async {
      snapshot.documents.forEach((documents) {
        final Cliente cliente =
            Cliente.fromMap(documents.data, documents.documentID);
        _list.add(cliente);
      });
    }).whenComplete(() {
      _clienteList = _list;
      notifyListeners();
    });
  }

  void setAutenticado({Cliente cliente}) {
    bool autenticado;
    if (_clienteActual != null) {
      autenticado = _clienteActual.estaAutenticado == false ? true : false;
    }
    try {
      _repository.setAutenticado(
          cliente == null ? _clienteActual.clienteID : cliente.clienteID,
          autenticado: autenticado);
      _clienteActual.estaAutenticado = autenticado;
      getClientes();
    } catch (e) {}
  }

  List<Pedido> _pedidoList = [];

  UnmodifiableListView<Pedido> get pedidoList =>
      UnmodifiableListView(_pedidoList);

  set pedidoList(List<Pedido> pedidoList) {
    _pedidoList = pedidoList;
    notifyListeners();
  }

  void getPedidosCliente(PedidoNotifier pedido) {
    pedido.pedidoList
        .where((ped) => ped.cliente.clienteID == _clienteActual.clienteID)
        .forEach((cli) {
      _pedidoList.add(cli);
    });
  }

  void pedidoListClear() {
    _pedidoList.clear();
    notifyListeners();
  }

  Cliente get clienteActual => _clienteActual;

  set clienteList(List<Cliente> clienteList) {
    _clienteList = clienteList;
    notifyListeners();
  }

  set clienteActual(Cliente clienteActual) {
    _clienteActual = clienteActual;
    notifyListeners();
  }
}
