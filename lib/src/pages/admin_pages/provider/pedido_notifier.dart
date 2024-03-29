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

  List<Pedido> _filterList = [];
  UnmodifiableListView<Pedido> get filterList =>
      UnmodifiableListView(_filterList);

  PedidoNotifier.init() {
    getPedidos();
  }

  bool filtrar({String char}) {
    bool empty = false;
    switch (char) {
      case 'E':
        _filterList = _pedidoList
            .where((element) => element.estadoEntrega == EnumEntrega.Entregado)
            .toList();
        break;
      case 'EP':
        _filterList = _pedidoList
            .where(
                (element) => element.estadoEntrega == EnumEntrega.EnPreparacion)
            .toList();
        break;
      case 'C':
        _filterList = _pedidoList
            .where((element) => element.estadoEntrega == EnumEntrega.Cancelado)
            .toList();
        break;
      case 'P':
        _filterList = _pedidoList.where((element) => element.pagado).toList();
        break;
      case 'NP':
        _filterList = _pedidoList.where((element) => !element.pagado).toList();
        break;
      default:
        _filterList.clear();
    }
    if (_filterList.isEmpty) {
      empty = true;
    }
    notifyListeners();
    return empty;
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
      _list.sort((a, b) => b.fecha.toDate().compareTo(a.fecha.toDate()));
      _pedidoList = _list;
      notifyListeners();
    });
  }

  void setPagado() {
    final bool pagado = _pedidoActual.pagado == false ? true : false;
    // final bool pagado = !_pedidoActual.pagado;
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

  set filterList(List<Pedido> pedidoList) {
    _filterList = pedidoList;
    notifyListeners();
  }

  set pedidoActual(Pedido pedidoActual) {
    _pedidoActual = pedidoActual;
    notifyListeners();
  }
}
