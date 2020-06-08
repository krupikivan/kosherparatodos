class Producto {
  List categorias;
  String productoID;
  String codigo;
  String descripcion;
  bool habilitado;
  String imagen;
  double precio;
  int stock;
  String unidadMedida;

  Producto({
    this.categorias,
    this.productoID,
    this.codigo,
    this.descripcion,
    this.habilitado,
    this.imagen,
    this.precio,
    this.stock,
    this.unidadMedida,
  });

  Producto.fromTextEditingController({
    this.productoID,
    this.codigo,
    this.descripcion,
    this.habilitado,
    this.imagen,
    this.precio,
    this.stock,
    this.unidadMedida,
  });

  Producto.fromProductosCollection(Map<String, dynamic> data, this.productoID) {
    categorias = categoriaListFill(data['categorias'] as List).cast<String>();
    // productoID = producto;
    codigo = data['codigo'] as String;
    descripcion = data['descripcion'] as String;
    habilitado = data['habilitado'] as bool;
    imagen = data['imagen'] as String;
    precio = data['precio'].toDouble() as double;
    stock = data['stock'].toInt() as int;
    unidadMedida = data['unidadMedida'] as String;
  }

  List categoriaListFill(List list) {
    final List<String> _list = [];
    for (var item in list) {
      _list.add(item);
    }
    return _list;
  }

  Producto.newProducto(this.categorias, this.productoID, this.descripcion,
      this.habilitado, this.imagen, this.precio, this.stock, this.unidadMedida);
  // Producto.newProducto(List cate, String idProd, String desc, bool hab, String img, double pre, int stk, String um) {
  //   categorias = cate;
  //   productoID = idProd;
  //   descripcion = desc;
  //   habilitado = hab;
  //   imagen = img;
  //   precio = pre;
  //   stock = stk;
  //   unidadMedida = um;
  // }

  // List<Opcion> getOpcionesList(List list){
  //   List<Opcion> _list = List();
  //   for(var opcion in list){
  //     _list.add(Opcion.fromFirebase(opcion));
  //   }
  //   return _list;
  // }

}

class ItemPedido {
  int cantidad;
  String descripcion;
  double precio;
  String productoID;

  ItemPedido({
    this.cantidad,
    this.descripcion,
    this.precio,
    this.productoID,
  });

  ItemPedido.fromGetPedidos(Map<String, dynamic> data) {
    cantidad = data['cantidad'] as int;
    descripcion = data['descripcion'] as String;
    precio = data['precio'] as double;
    productoID = data['productoID'] as String;
  }

  ItemPedido.fromUpdateCarrito(Producto producto, int cantidad) {
    cantidad = cantidad;
    descripcion = producto.descripcion;
    precio = producto.precio;
    productoID = producto.productoID;
  }

  Map<String, dynamic> toPedidoOnFirebase() => {
        'cantidad': cantidad,
        'descripcion': descripcion,
        'precio': precio,
        'productoID': productoID
      };
}
