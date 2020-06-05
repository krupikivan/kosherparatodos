class Categoria {

  String categoriaID;
  String nombre;
  List<String> ancestro;
  bool selected;
  bool esPadre;

  Categoria({
    this.categoriaID,
    this.nombre,
    this.ancestro,
    this.selected,
    this.esPadre,
  });

  Categoria.fromFirebase(Map<String, dynamic> data, categoria) {
    categoriaID = categoria;
    nombre = data['nombre'];
    ancestro = getAncestrosList(data['ancestro']);
    selected = false;
    esPadre = data['esPadre'];
  }
  
  Categoria.fromPrincipal(data) {
    nombre = data['nombre'];
    categoriaID = data['id'];
  }

  Categoria.fromShowOnNewProduct(data) {
    nombre = data['nombre'];
    categoriaID = data.documentID;
    selected = false;
    esPadre = data['esPadre'];
  }

  Categoria.fromHijo(data) {
    nombre = data['nombre'];
    categoriaID = data.documentID;
  }

  List<String> getAncestrosList(List list){
    List<String> _list = List();
    for(var ancestro in list){
      _list.add(ancestro);
    }
    return _list;
  }

}
