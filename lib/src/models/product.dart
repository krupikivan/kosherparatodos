import 'package:cloud_firestore/cloud_firestore.dart';

class Producto{
  
  String idProducto;
  String bulto;
  String nombre;
  double precioUnitario;
  Timestamp ultimaActualizacion;
  String unidadMedida;
  String image;
  String descripcion;
  String tipo;
  List opcionCantidad;

  Producto({
    this.idProducto,
    this.bulto,
    this.nombre,
    this.precioUnitario,
    this.ultimaActualizacion,
    this.unidadMedida,
    this.image,
    this.descripcion,
    this.tipo,
    this.opcionCantidad,
  });
}