import 'package:kosherparatodos/src/models/producto_concreto.dart';

class DetallePedido{

  ProductoConcreto concreto; //Es igual al id del producto concreto
  double cantidad;
  double precioDetalle;

  DetallePedido({
    this.concreto,
    this.cantidad,
    this.precioDetalle,
  });

}