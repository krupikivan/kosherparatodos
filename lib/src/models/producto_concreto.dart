class ProductoConcreto{
  
  String id;
  String productoId;
  double cantidad;
  double precioTotal;
  double precioUnitario;
  String descripcion;
  String unidadMedida;
  int cantidadPedido;

  ProductoConcreto({
    this.id,
    this.productoId,
    this.cantidad,
    this.precioTotal,
    this.descripcion,
    this.precioUnitario,
    this.unidadMedida,
    this.cantidadPedido = 0,
  });
}