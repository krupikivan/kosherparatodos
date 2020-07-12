class Producto {
  List categorias;
  String productoID;
  String marca;
  String codigo;
  String descripcion;
  bool habilitado;
  String imagen;
  double precio;
  int stock;
  String unidadMedida;

  Producto({
    this.categorias,
    this.marca,
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
    this.marca,
    this.descripcion,
    this.habilitado,
    this.imagen,
    this.precio,
    this.stock,
    this.unidadMedida,
  });

  Producto.fromProductosCollection(Map<String, dynamic> data, this.productoID) {
    categorias = categoriaListFill(data['categorias'] as List).cast<String>();
    codigo = data['codigo'] as String;
    marca = data['marca'] as String;
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
}

class ItemPedido {
  int cantidad;
  String descripcion;
  double precio;
  String productoID;
  String marca;

  ItemPedido({
    this.cantidad,
    this.descripcion,
    this.precio,
    this.productoID,
    this.marca,
  });

  ItemPedido.fromGetPedidos(Map<String, dynamic> data) {
    cantidad = data['cantidad'] as int;
    descripcion = data['descripcion'] as String;
    marca = data['marca'] as String;
    precio = data['precio'] as double;
    productoID = data['productoID'] as String;
  }

  ItemPedido.fromUpdateCarrito(Producto producto, int cantidad) {
    cantidad = cantidad;
    marca = producto.marca;
    descripcion = producto.descripcion;
    precio = producto.precio;
    productoID = producto.productoID;
  }

  Map<String, dynamic> toPedidoOnFirebase() => {
        'cantidad': cantidad,
        'descripcion': descripcion,
        'marca': marca,
        'precio': precio,
        'productoID': productoID
      };
}
