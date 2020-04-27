import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kosherparatodos/src/models/producto_concreto.dart';

class Producto{
  
  String idProducto;
  String nombre;
  String descripcion;
  Timestamp ultimaActualizacion;
  List<ProductoConcreto> concreto;
  String imagen;
  bool habilitado;
  double precioUnitario;

  Producto({
    this.idProducto,
    this.nombre,
    this.ultimaActualizacion,
    this.imagen,
    this.descripcion,
    this.precioUnitario,
    this.concreto,
    this.habilitado,
  });

  Producto.fromMap(Map<String, dynamic> data, id){
    idProducto = id;
    nombre = data['nombre'];
    habilitado = data['habilitado'];
    descripcion = data['descripcion'];
    ultimaActualizacion = data['ultimaActualizacion'];
    precioUnitario = data['precioUnitario'].toDouble();
  }

    Producto.fromNewProd(nom, des, pre, hab, List<ProductoConcreto> list){
      nombre = nom;
      descripcion = des;
      precioUnitario = pre;
      habilitado = hab;
      concreto = getNewConcretoList(list, pre);
  }

    List<ProductoConcreto> getNewConcretoList(List<ProductoConcreto> list, pre){
    List<ProductoConcreto> _list = List();
    for(var concreto in list){
      var precio = 0.0;
      if(pre != 0.0){
        precio = pre * concreto.cantidad;
      }
      _list.add(ProductoConcreto.fromNewConcreto(concreto, precio));
    }
    return _list;
  }

}