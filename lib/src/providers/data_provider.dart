import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/repository/firestore_provider.dart';
import 'package:kosherparatodos/src/repository/repo.dart';

class DataProvider with ChangeNotifier {
  final Repository _repository = FirestoreProvider();

  List _estadoEntrega = [];
  UnmodifiableListView get getEstadoEntrega =>
      UnmodifiableListView(_estadoEntrega);

  int _costoEnvio;
  int get costoEnvio => _costoEnvio;

  DataProvider.init() {
    _getDatosUtiles();
  }

  void _getDatosUtiles() async {
    await _repository.getDatosUtiles().then((data) {
      final EstadoEntrega _ee =
          EstadoEntrega.fromMap(data['estadoEntrega'] as List);
      _estadoEntrega = _ee.entrega;
      _costoEnvio = data['envio'] as int;
      notifyListeners();
    });
  }
}
