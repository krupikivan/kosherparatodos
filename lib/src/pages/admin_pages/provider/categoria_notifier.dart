import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:kosherparatodos/src/models/categoria.dart';
import 'package:kosherparatodos/src/repository/firestore_provider.dart';
import 'package:kosherparatodos/src/repository/repo.dart';

class CategoriaNotifier with ChangeNotifier {
  final Repository _repository = FirestoreProvider();

  List<Categoria> _categoriaList = [];

  UnmodifiableListView<Categoria> get categoriaList =>
      UnmodifiableListView(_categoriaList);

  CategoriaNotifier.init() {
    getCategorias();
  }

  getCategorias() {
    List<Categoria> _list = [];
    _repository.getCategorias().onData((listCate) {
      listCate.documents.forEach((categoria) {
          Categoria _categoria =
              Categoria.fromFirebase(categoria.data, categoria.documentID);
          _list.add(_categoria);
          _categoriaList = _list;
          notifyListeners();
      });
    });
  }

  changeSelected(id, val){
    Categoria cat = _categoriaList.firstWhere((element) => element.idCategoria == id);
    cat.selected = val;
    notifyListeners();
  }

  set  categoriaList(List<Categoria> categoriaList) {
    _categoriaList = categoriaList;
    notifyListeners();
  }

}
