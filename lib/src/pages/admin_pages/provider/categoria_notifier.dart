import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:kosherparatodos/src/models/categoria.dart';
import 'package:kosherparatodos/src/repository/firestore_provider.dart';
import 'package:kosherparatodos/src/repository/repo.dart';

class CategoriaNotifier with ChangeNotifier {
  final Repository _repository = FirestoreProvider();

  CategoriaNotifier.init() {
    getCategorias();
  }

  getCategorias(){
    List<Categoria> _list = [];
    _repository.getCategoriasPrincipal().then((value) {
      List _listPrincipal = value.data['categorias'];
      _listPrincipal.forEach((element) {
        Categoria _categoria = Categoria.fromPrincipal(element);
        _list.add(_categoria);
      });
      _categoriaPadreList = _list;
      notifyListeners();
    });
  }

  getAllCategorias(){
    List<Categoria> _list = [];
    _repository.getAllCategorias().then((value) {
      List _listAllCategorias = value.documents;
      _listAllCategorias.forEach((element) {
        Categoria _categoria = Categoria.fromShowOnNewProduct(element);
        _list.add(_categoria);
      });
      _categoriaList = _list;
      notifyListeners();
    });
  }

    getCategoriasHijos(){
      _categoriaHijoSelected = null;
    List<Categoria> _list = [];
    _repository.getCategoriasHijos(_categoriaPadreSelected.categoriaID).then((value) {
      List _listHijos = value.documents;
      _listHijos.forEach((element) {
        Categoria _categoria = Categoria.fromHijo(element);
        _list.add(_categoria);
      });
      _categoriaHijoList = _list;
      notifyListeners();
    });
  }

  // getCategorias() {
  //   List<Categoria> _list = [];
  //   _repository.getCategorias().onData((listCate) {
  //     listCate.documents.forEach((categoria) {
  //         Categoria _categoria =
  //             Categoria.fromFirebase(categoria.data, categoria.documentID);
  //         _list.add(_categoria);
  //         _categoriaList = _list;
  //         notifyListeners();
  //     });
  //   });
  // }

    creatingCategoria(Categoria nuevo){
    _categoriaNueva = nuevo;
    _categoriaNueva.ancestro = nuevo.esPadre == false ? _categoriaString : [];
    // notifyListeners();
  }

  addNewCategoria() {
    _repository.addNewCategoria(_categoriaNueva).whenComplete(() => _clearCategoriaNueva());
  }

  _clearCategoriaNueva(){
    _categoriaString.clear();
    _categoriaNueva = null;
  }

  changeSelected(id, val){
    Categoria cat = _categoriaList.firstWhere((element) => element.categoriaID == id);
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
  setPadreSelected(Categoria cate){
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
  Categoria _categoriaNueva;
  Categoria get categoriaNueva => _categoriaNueva;
  set categoriaNueva(Categoria categoriaNueva) {
    _categoriaNueva = categoriaNueva;
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
