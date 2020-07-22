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
    getAllCategorias();
  }

//Traemos una sola vez todas las categorias y en la app dividimos padres e hijos
  Future getAllCategorias() async {
    final List<Categoria> _list = [];
    await _repository.getAllCategorias().then((value) {
      value.documents.forEach((data) {
        final Categoria _categoria = Categoria.fromDatabase(data);
        _list.add(_categoria);
      });
      _categoriaList = _list; //Este listado contiene todas las categorias
      //Decidimos quien es Padre
      _categoriaPadreList = _list.where((element) => element.esPadre).toList();
      notifyListeners();
    });
  }

  void clearHijos() {
    _categoriaHijoList.clear();
    notifyListeners();
  }

  void changeCategoria(Categoria categoria, String name) {
    _categoriaPadreList
        .firstWhere((element) => element.categoriaID == categoria.categoriaID)
        .nombre = name;
    notifyListeners();
    _repository.changeCategoryName(categoria, name);
  }

  void addNewCategoria(Categoria nueva) {
    if (_conex.hasConnection) {
      nueva.ancestro = _categoriaString;
      _repository
          .addNewCategoria(nueva)
          .then((value) => true)
          .catchError((onError) => throw 'Error')
          .whenComplete(() {
        getAllCategorias();
        clearListString();
      }).catchError((error) => throw 'Error');
    } else {
      throw 'No hay conexion';
    }
  }

  void getHijos({int index}) {
    _categoriaPadreSelected = null;
    _categoriaHijoSelected = null;
    String padreId = '';
    if (index != null) {
      _categoriaPadreSelected = _categoriaPadreList[index];
      padreId = _categoriaPadreSelected.categoriaID;
      _categoriaHijoList = _categoriaList
          .where((element) => element.ancestro.contains(padreId))
          .toList();
    } else {
      _categoriaHijoList =
          _categoriaList.where((element) => !element.esPadre).toList();
    }
    notifyListeners();
  }

  void clearListString() {
    _categoriaPadreList.forEach((element) => element.selected = false);
    if (_categoriaHijoList.isNotEmpty) {
      _categoriaHijoList.forEach((element) => element.selected = false);
    }
    _categoriaString.clear();
    notifyListeners();
  }

  void changeSelected(String id, bool val, bool esProducto) {
    Categoria cat;
    if (!esProducto) {
      cat = _categoriaPadreList
          .firstWhere((element) => element.categoriaID == id);
    } else {
      cat =
          _categoriaHijoList.firstWhere((element) => element.categoriaID == id);
    }
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

//---------------------------Todas las Categorias
  List<Categoria> _categoriaList = [];
  UnmodifiableListView<Categoria> get categoriaList =>
      UnmodifiableListView(_categoriaList);
  set categoriaList(List<Categoria> categoriaList) {
    _categoriaList = categoriaList;
    notifyListeners();
  }

  //---------------------------Categorias ancestros para la nueva categoria
  List<String> _categoriaString = [];
  List<String> get categoriaString => _categoriaString;
  set categoriaString(List<String> categoriaString) {
    _categoriaString = categoriaString;
    notifyListeners();
  }
}
