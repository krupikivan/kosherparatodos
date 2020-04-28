class ProductoConcreto {
  String idConcreto;
  String idProducto;
  int cantidad;
  double precioTotal;
  String descripcion;
  var cantidadPedido;

  ProductoConcreto({
    this.idConcreto,
    this.idProducto,
    this.cantidad,
    this.precioTotal,
    this.descripcion,
    this.cantidadPedido = 0,
  });

  ProductoConcreto.fromMap(Map<String, dynamic> data, id) {
    idConcreto = id;
    cantidad = data['cantidad'].toInt();
    precioTotal = data['precioTotal'].toDouble();
    descripcion = data['descripcion'];
  }

  ProductoConcreto.fromNewConcreto(ProductoConcreto concreto, precio) {
    cantidad = concreto.cantidad;
    descripcion = concreto.descripcion;
    precioTotal = precio == 0.0 ? concreto.precioTotal : precio;
  }

  ProductoConcreto.fromEditPedido(data) {
    idConcreto = data['idConcreto'];
    idProducto = data['idProducto'];
  }

  ProductoConcreto.fromFirebase(data, id, idProd) {
    precioTotal = data['precioTotal'].toDouble(); 
    cantidad = data['cantidad'].toInt();
    descripcion = data['descripcion'];
    idConcreto = id;
    idProducto = idProd;
  }
}
