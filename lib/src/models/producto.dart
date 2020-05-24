
class Producto{
  
  List<String> categorias;
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

  Producto.fromGetProductos(Map<String, dynamic> data, producto){
    categorias = categoriaListFill(data['categorias']);
    productoID = producto;
    codigo = data['codigo'];
    descripcion = data['descripcion'];
    habilitado = data['habilitado'];
    imagen = data['imagen'];
    precio = data['precio'].toDouble();
    stock = data['stock'];
    unidadMedida = data['unidadMedida'];
  }

  categoriaListFill(List list){
    List<String> _list = List();
    for(var item in list){
      _list.add(item);
    }
    return _list;
  }

  Producto.newProducto(cate, idProd, desc, hab, img, pre, stk, um){
    categorias = cate;
    productoID = idProd;
    descripcion = desc;
    habilitado = hab;
    imagen = img;
    precio = pre;
    stock = stk;
    unidadMedida = um;
  }

  // List<Opcion> getOpcionesList(List list){
  //   List<Opcion> _list = List();
  //   for(var opcion in list){
  //     _list.add(Opcion.fromFirebase(opcion));
  //   }
  //   return _list;
  // }

}

class ItemPedido{

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
    cantidad = data['cantidad'];
    descripcion = data['descripcion'];
    precio = data['precio'];
    productoID = data['productoID'];
  }

 Map<String, dynamic> toPedidoOnFirebase() => {
    'cantidad': this.cantidad,
    'descripcion': this.descripcion,
    'precio': this.precio,
    'productoID': this.productoID
 };

}