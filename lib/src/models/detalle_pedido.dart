import 'package:kosherparatodos/src/models/producto_concreto.dart';

class DetallePedido{

  ProductoConcreto concreto; //Es igual al id del producto concreto
  var cantidad;
  var precioDetalle; //Puede venir INT o DOUBLE
  String descripcion;
  var precioUnitario;

  DetallePedido({
    this.concreto,
    this.cantidad,
    this.precioDetalle,
    this.descripcion,
    this.precioUnitario,
  });


  DetallePedido.fromMap(Map<String, dynamic> data){
    cantidad = data['cantidad'];
    precioDetalle = data['precioDetalle'];
    descripcion = data['descripcion'];
    precioUnitario = data['precioUnitario'];
  }

}