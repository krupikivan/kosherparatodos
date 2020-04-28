import 'package:kosherparatodos/src/models/producto_concreto.dart';

class DetallePedido {
  ProductoConcreto concreto; //Es igual al id del producto concreto
  var cantidad;
  var precioDetalle; //Puede venir INT o DOUBLE
  String descripcion;
  var precioUnitario;
  String idDetallePedido;

  DetallePedido({
    this.concreto,
    this.cantidad,
    this.precioDetalle,
    this.descripcion,
    this.precioUnitario,
    this.idDetallePedido,
  });

  DetallePedido.fromFirebase(Map<String, dynamic> data, id) {
    precioDetalle = data['precioDetalle'].toDouble();
    descripcion = data['descripcion'];
    idDetallePedido = id;
    precioUnitario = data['precioUnitario'];
    cantidad = data['cantidad'];
    concreto = ProductoConcreto.fromEditPedido(data);
  }

  DetallePedido.fromMap(Map<String, dynamic> data) {
    cantidad = data['cantidad'];
    precioDetalle = data['precioDetalle'];
    descripcion = data['descripcion'];
    precioUnitario = data['precioUnitario'];
  }

    DetallePedido.fromAddingNew(ProductoConcreto pc) {
      concreto = pc;
      precioUnitario = pc.precioTotal;
      cantidad = 1;
      descripcion = pc.descripcion;
      precioDetalle = pc.precioTotal * cantidad;
  }
}
