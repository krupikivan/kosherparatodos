class ProductoConcreto{
  
  String id;
  double cantidad;
  double precioTotal;
  double precioUnitario;
  String descripcion;
  String unidadMedida;
  int cantidadPedido;

  ProductoConcreto({
    this.id,
    this.cantidad,
    this.precioTotal,
    this.descripcion,
    this.precioUnitario,
    this.unidadMedida,
    this.cantidadPedido = 0,
  });
}