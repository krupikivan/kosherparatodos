import 'package:kosherparatodos/src/models/producto_concreto.dart';

class DetallePedido{

  ProductoConcreto concreto; //Es igual al id del producto concreto
  double cantidad;
  double precioDetalle;
  String descripcion;

  DetallePedido({
    this.concreto,
    this.cantidad,
    this.precioDetalle,
    this.descripcion,
  });

}