import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:kosherparatodos/src/models/categoria.dart';
import 'package:kosherparatodos/src/providers/connectivity.dart';
import 'package:kosherparatodos/src/repository/firestore_provider.dart';
import 'package:kosherparatodos/src/repository/repo.dart';

class CategoriaNotifier with ChangeNotifier {
  final Repository _repository = FirestoreProvider();
  final _conex = ConnectivityProvider.getInstance();

  CategoriaNotifier.init() {
    getCategoriasPrincipales();
  }

  Future getCategoriasPrincipales() async {
    final List<Categoria> _list = [];
    await _repository.getCategoriasPrincipal().then((DocumentSnapshot value) {
      final List _listPrincipal = value.data['categorias'] as List;
      _listPrincipal.forEach((element) {
        final Categoria _categoria = Categoria.fromPrincipal(element);
        _list.add(_categoria);
      });
      _categoriaPadreList = _list;
      notifyListeners();
    });
  }

  void getAllCategoriasHijos() {
    if (_categoriaList.isEmpty) {
      final List<Categoria> _list = [];
      _repository.getAllCategoriasHijos().then((value) {
        final List _listAllCategorias = value.documents;
        _listAllCategorias.forEach((element) {
          final Categoria _categoria = Categoria.fromShowOnNewProduct(element);
          _list.add(_categoria);
        });
        _categoriaList = _list;
        notifyListeners();
      });
    }
  }

  void getCategoriasHijos() {
    _categoriaHijoSelected = null;
    final List<Categoria> _list = [];
    _repository
        .getCategoriasHijos(_categoriaPadreSelected.categoriaID)
        .then((value) {
      final List _listHijos = value.documents;
      _listHijos.forEach((element) {
        final Categoria _categoria = Categoria.fromHijo(element);
        _list.add(_categoria);
      });
      _categoriaHijoList = _list;
      notifyListeners();
    });
  }

  void addNewCategoria(Categoria nueva) {
    if (_conex.hasConnection) {
      nueva.ancestro = _categoriaString;
      _repository
          .addNewCategoria(nueva)
          .then((value) => true)
          .catchError((onError) => throw 'Error')
          .whenComplete(() {
        getCategoriasPrincipales();
        _clearCategoriaNueva();
      }).catchError((error) => throw 'Error');
    } else {
      throw 'No hay conexion';
    }
  }

  void _clearCategoriaNueva() {
    _categoriaPadreList.forEach((element) => element.selected = false);
    _categoriaString.clear();
    notifyListeners();
    // _categoriaNueva = null;
  }

  void changeSelected(String id, bool val) {
    final Categoria cat =
        _categoriaPadreList.firstWhere((element) => element.categoriaID == id);
    cat.selected = val;
    notifyListeners();
  }

//---------------------------Categoria padre listado
  List<Categoria> _categoriaPadreList = [];
  UnmodifiableListView<Categoria> get categoriaPadreList =>
      UnmodifiableListView(_categoriaPadreList);
  set categoriaPadreList(List<Categoria> categoriaList) {
    _categoriaPadreList = categoriaList;
    notifyListeners();
  }

//---------------------------Categoria padre seleccionada
  Categoria _categoriaPadreSelected;
  Categoria get categoriaPadreSelected => _categoriaPadreSelected;
  set categoriaPadreSelected(Categoria categoriaPS) {
    _categoriaPadreSelected = categoriaPS;
    notifyListeners();
  }

  void setPadreSelected(Categoria cate) {
    _categoriaPadreSelected = cate;
    getCategoriasHijos();
  }

//---------------------------Categoria hijo seleccionada
  Categoria _categoriaHijoSelected;
  Categoria get categoriaHijoSelected => _categoriaHijoSelected;
  set categoriaHijoSelected(Categoria categoriaPS) {
    _categoriaHijoSelected = categoriaPS;
    notifyListeners();
  }

//---------------------------Categoria hijos
  List<Categoria> _categoriaHijoList = [];
  UnmodifiableListView<Categoria> get categoriaHijoList =>
      UnmodifiableListView(_categoriaHijoList);
  set categoriaHijoList(List<Categoria> categoriaList) {
    _categoriaHijoList = categoriaList;
    notifyListeners();
  }

//---------------------------Categoria hijos todos
  List<Categoria> _categoriaList = [];
  UnmodifiableListView<Categoria> get categoriaList =>
      UnmodifiableListView(_categoriaList);
  set categoriaList(List<Categoria> categoriaList) {
    _categoriaList = categoriaList;
    notifyListeners();
  }

  //---------------------------Categoria que estoy creando
  // Categoria _categoriaNueva;
  // Categoria get categoriaNueva => _categoriaNueva;
  // set categoriaNueva(Categoria categoriaNueva) {
  //   _categoriaNueva = categoriaNueva;
  //   notifyListeners();
  // }

  //---------------------------Categorias ancestros para la nueva categoria
  List<String> _categoriaString = [];
  List<String> get categoriaString => _categoriaString;
  set categoriaString(List<String> categoriaString) {
    _categoriaString = categoriaString;
    notifyListeners();
  }
}
