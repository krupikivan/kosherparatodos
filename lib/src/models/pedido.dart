import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kosherparatodos/src/models/producto.dart';

import 'cliente.dart';

enum Estado { CANCELADO, ENPREPARACION, ENTREGADO }

class Pedido {
  String idPedido;
  Cliente cliente;
  Estado estado;
  Timestamp fecha;
  bool pagado;
  List<Detalle> productos;
  double total;

  Pedido({
    this.idPedido,
    this.cliente,
    this.estado,
    this.fecha,
    this.pagado,
    this.total,
    this.productos,
  });

  Pedido.fromFirebase(Map<String, dynamic> data, String pedido, String cli) {
    idPedido = pedido;
    cliente = Cliente.fromMap(data, cli);
    estado = getEstado(data['estado']);
    fecha = data['fecha'];
    pagado = data['pagado'];
    productos = getProductosList(data['productos']);
    total = data['total'].toDouble();
  }
  Pedido.fromPedidos(Map<String, dynamic> data, String pedido) {
    idPedido = pedido;
    cliente = Cliente.fromPedidos(data);
    estado = getEstado(data['estado']);
    fecha = data['fecha'];
    pagado = data['pagado'];
    productos = getProductosList(data['productos']);
    total = data['total'].toDouble();
  }


  List<Detalle> getProductosList(List list){
    List<Detalle> _list = List();
    for(var producto in list){
      _list.add(Detalle.fromGetPedidos(producto));
    }
    return _list;
  }

  String getEstadoString(Estado estado) {
    switch (estado) {
      case Estado.ENPREPARACION:
        return "En preparacion";
        break;
      case Estado.CANCELADO:
        return "Cancelado";
        break;
      case Estado.ENTREGADO:
        return "Entregado";
        break;
    }
    return "Cancelado";
  }

  Estado getEstado(var estado) {
    switch (estado) {
      case "En preparacion":
        return Estado.ENPREPARACION;
        break;
      case "Cancelado":
        return Estado.CANCELADO;
        break;
      case "Entregado":
        return Estado.ENTREGADO;
        break;
    }
    return Estado.CANCELADO;
  }
}

class Detalle{

  int cantidad;
  String descripcion;
  String productoID;
  double precio;

  Detalle({
    this.cantidad,
    this.descripcion,
    this.productoID,
    this.precio,
  });

  Detalle.fromGetPedidos(Map<String, dynamic> data) {
    cantidad = data['cantidad'];
    descripcion = data['descripcion'];
    productoID = data['productoID'];
    precio = data['precio'].toDouble();
  }

  // Detalle.fromOpcionSeleccionada(Producto prod) {
  //   cantidad = prod.cantidad;
  //   descripcion = prod.codigo;
  //   productoID = prod.productoID;
  //   precio = prod.precio;
  // }

 Map<String, dynamic> toFirebase() => {
    'cantidad': this.cantidad,
    'codigo': this.descripcion,
    'idProducto': this.productoID,
    'precio': this.precio
 };
}
