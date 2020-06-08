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

  Categoria.fromFirebase(Map<String, dynamic> data, this.categoriaID) {
    nombre = data['nombre'] as String;
    ancestro = getAncestrosList(data['ancestro'] as List<String>);
    selected = false;
    esPadre = data['esPadre'] as bool;
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

  List<String> getAncestrosList(List<String> list) {
    final List<String> _list = [];
    for (String ancestro in list) {
      _list.add(ancestro);
    }
    return _list;
  }
}
