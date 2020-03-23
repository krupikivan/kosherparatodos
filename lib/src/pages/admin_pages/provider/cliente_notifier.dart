import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:kosherparatodos/src/models/cliente.dart';
import 'package:kosherparatodos/src/repository/firestore_provider.dart';
import 'package:kosherparatodos/src/repository/repo.dart';

class ClienteNotifier with ChangeNotifier {
  final Repository _repository = FirestoreProvider();

  List<Cliente> _clienteList = [];
  Cliente _clienteActual;

  UnmodifiableListView<Cliente> get clienteList =>
      UnmodifiableListView(_clienteList);

  ClienteNotifier.instance() {
    getClientes();
  }

  getClientes() async {
    List<Cliente> _list = [];
    await _repository.getClientes().then((snapshot) {
      snapshot.documents.forEach((documents) {
        Cliente cliente = Cliente.fromMap(documents.data);
        _list.add(cliente);
      });
    });
    this._clienteList = _list;
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
