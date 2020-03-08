import 'package:cloud_firestore/cloud_firestore.dart';

class Producto{
  
  String idProducto;
  String name;
  int costo;
  Timestamp ultimaActualizacion;
  int cantidad;
  String unidadMedida;
  String image;

  Producto({
    this.idProducto,
    this.name,
    this.costo,
    this.ultimaActualizacion,
    this.cantidad,
    this.unidadMedida,
    this.image,
  });
}