import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kosherparatodos/src/models/producto_concreto.dart';

class Producto{
  
  String idProducto;
  String bulto;
  String nombre;
  String descripcion;
  Timestamp ultimaActualizacion;
  List<ProductoConcreto> concreto;
  String imagen;
  bool habilitado;

  Producto({
    this.idProducto,
    this.bulto,
    this.nombre,
    this.ultimaActualizacion,
    this.imagen,
    this.descripcion,
    this.concreto,
    this.habilitado,
  });
}