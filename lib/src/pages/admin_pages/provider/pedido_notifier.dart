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
    _getEstadosEntrega();
  }

  void getPedidos() {
    final List<Pedido> _list = [];
    _repository.getAllPedidos().onData((listPed) {
      _pedidoList.clear();
      listPed.documents.forEach((pedido) {
        final Pedido _pedido =
            Pedido.fromPedidos(pedido.data, pedido.documentID);
        _list.add(_pedido);
      });
      _pedidoList = _list;
      notifyListeners();
    });
  }

  void _getEstadosEntrega() async {
    await _repository.getEstadoEntrega().then((data) {
      final EstadoEntrega _ee = EstadoEntrega.fromMap(data['estado'] as List);
      _estadoEntrega = _ee.entrega;
      notifyListeners();
    });
  }

  void setPagado() {
    final bool pagado = _pedidoActual.pagado == false ? true : false;
    try {
      _repository.setPagado(_pedidoActual.pedidoID, pagado: pagado);
      _pedidoActual.pagado = pagado;
      getPedidos();
    } catch (e) {
      print(e);
    }
  }

  void setEstadoEntrega(EnumEntrega value) {
    try {
      _repository.setEstadoEntrega(_pedidoActual.pedidoID, value);
      _pedidoActual.estadoEntrega = value;
      getPedidos();
    } catch (e) {
      print(e);
    }
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

  UnmodifiableListView get getEstadoEntrega =>
      UnmodifiableListView(_estadoEntrega);
}
