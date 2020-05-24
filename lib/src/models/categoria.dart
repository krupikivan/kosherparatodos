class Categoria {

  String idCategoria;
  String nombre;
  List<String> ancestro;
  bool selected;

  Categoria({
    this.idCategoria,
    this.nombre,
    this.ancestro,
    this.selected,
  });

  Categoria.fromFirebase(Map<String, dynamic> data, categoria) {
    idCategoria = categoria;
    nombre = data['nombre'];
    ancestro = getAncestrosList(data['ancestro']);
    selected = false;
  }

  List<String> getAncestrosList(List list){
    List<String> _list = List();
    for(var ancestro in list){
      _list.add(ancestro);
    }
    return _list;
  }

}
