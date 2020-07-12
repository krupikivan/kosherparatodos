import 'package:cloud_firestore/cloud_firestore.dart';

class Categoria {
  String categoriaID;
  String nombre;
  List ancestro;
  bool selected;
  bool esPadre;

  Categoria({
    this.categoriaID,
    this.nombre,
    this.ancestro,
    this.selected,
    this.esPadre,
  });

  Categoria.fromFirebase(Map<String, dynamic> data, this.categoriaID) {
    nombre = data['nombre'] as String;
    ancestro = getAncestrosList(data['ancestro'] as List);
    selected = false;
    esPadre = data['esPadre'] as bool;
  }

  Categoria.fromNew(this.nombre, this.esPadre, this.selected);

  Categoria.fromDatabase(DocumentSnapshot doc) {
    categoriaID = doc.documentID;
    nombre = doc.data['nombre'] as String;
    ancestro = getAncestrosList(doc.data['ancestro'] as List);
    selected = false;
    esPadre = doc.data['esPadre'] as bool;
  }

  Categoria.fromPrincipal(data) {
    nombre = data['nombre'] as String;
    categoriaID = data['id'] as String;
  }

  Categoria.fromShowOnNewProduct(data) {
    nombre = data['nombre'] as String;
    categoriaID = data.documentID as String;
    selected = false;
    esPadre = data['esPadre'] as bool;
  }

  Categoria.fromHijo(data) {
    nombre = data['nombre'] as String;
    categoriaID = data.documentID as String;
  }

  List getAncestrosList(List list) {
    final List _list = [];
    for (var ancestro in list) {
      _list.add(ancestro);
    }
    return _list;
  }
}
