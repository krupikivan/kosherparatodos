class ProductoConcreto {
  String idConcreto;
  String productoId;
  int cantidad;
  double precioTotal;
  String descripcion;
  var cantidadPedido;

  ProductoConcreto({
    this.idConcreto,
    this.productoId,
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
}
