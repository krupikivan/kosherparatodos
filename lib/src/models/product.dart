import 'package:cloud_firestore/cloud_firestore.dart';

class Producto{
  
  String idProducto;
  int costo;
  Timestamp ultimaActualizacion;
  int cantidad;
  String unidadMedida;
  String image;

  Producto({
    this.idProducto,
    this.costo,
    this.ultimaActualizacion,
    this.cantidad,
    this.unidadMedida,
    this.image,
  });
}