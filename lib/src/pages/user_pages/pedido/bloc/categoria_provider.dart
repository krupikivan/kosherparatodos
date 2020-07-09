import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:kosherparatodos/src/models/categoria.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/repository/firestore_provider.dart';
import 'package:kosherparatodos/src/repository/repo.dart';

class CategoriaProvider with ChangeNotifier {
  final Repository _repository = FirestoreProvider();

  CategoriaProvider.init() {
    getCategorias();
  }

  //---------------------------Categoria padre listado
  List<Categoria> _categoriaList = [];
  UnmodifiableListView<Categoria> get categoriaList =>
      UnmodifiableListView(_categoriaList);
  set categoriaList(List<Categoria> categoriaList) {
    _categoriaList = categoriaList;
    notifyListeners();
  }

  //---------------------------Categoria hijo listado
  List<Categoria> _categoriaHijoList = [];
  UnmodifiableListView<Categoria> get categoriaHijoList =>
      UnmodifiableListView(_categoriaHijoList);
  set categoriaHijoList(List<Categoria> categoriaList) {
    _categoriaHijoList = categoriaList;
    notifyListeners();
  }

  //---------------------------Listado productos
  List<Producto> _productoList = [];
  UnmodifiableListView<Producto> get productoList =>
      UnmodifiableListView(_productoList);
  set productoList(List<Producto> list) {
    _productoList = list;
    notifyListeners();
  }

  void changePadreSelected(Categoria categoria) {
    _categoriaList.forEach((cate) {
      if (cate == categoria) {
        _categoriaHijoList = _categoriaList
            .where((element) => element.ancestro.contains(cate.categoriaID))
            .toList();
        cate.selected = true;
      } else {
        cate.selected = false;
      }
    });
    notifyListeners();
  }

  void changeHijoSelected(Categoria categoria) {
    _categoriaHijoList.forEach((cate) {
      if (cate == categoria) {
        cate.selected = true;
      } else {
        cate.selected = false;
      }
    });
    notifyListeners();
  }

  void getProductos(Categoria categoria) {
    changeHijoSelected(categoria);
    if (_productoList.isEmpty) {
      getProductosHabilitados();
    }
  }

  bool sortProd(Producto prod) {
    final String id = _categoriaHijoList
        .firstWhere((element) => element.selected == true)
        .categoriaID;
    if (prod.categorias.contains(id)) {
      return true;
    }
    return false;
  }

  void getProductosHabilitados() async {
    final List<Producto> _listProd = [];
    final QuerySnapshot doc = await _repository.getProductosHabilitados();
    doc.documents.forEach((element) {
      final Producto producto =
          Producto.fromProductosCollection(element.data, element.documentID);
      _listProd.add(producto);
    });
    _productoList = _listProd;
    notifyListeners();
  }

  // Future getCategoriasPrincipales() async {
  //   final List<Categoria> _list = [];
  //   await _repository.getCategoriasPrincipal().then((DocumentSnapshot value) {
  //     final List _listPrincipal = value.data['categorias'] as List;
  //     _listPrincipal.forEach((element) {
  //       final Categoria _categoria = Categoria.fromPrincipal(element);
  //       _list.add(_categoria);
  //     });
  //     _categoriaPadreList = _list;
  //     notifyListeners();
  //   });
  // }

  void getCategorias() {
    final List<Categoria> _list = [];
    _repository.getAllCategorias().then((value) {
      value.documents.forEach((element) {
        final Categoria _categoria = Categoria.fromDatabase(element);
        _list.add(_categoria);
      });
      _categoriaList = _list;
      notifyListeners();
    });
  }
}
