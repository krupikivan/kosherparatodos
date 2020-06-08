import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'cliente.dart';

class Pedido {
  String pedidoID;
  Cliente cliente;
  String estado;
  Timestamp fecha;
  bool pagado;
  List productos;
  double total;

  Pedido({
    this.pedidoID,
    this.cliente,
    this.estado,
    this.fecha,
    this.pagado,
    this.total,
    this.productos,
  });

  Pedido.fromFirebase(Map<String, dynamic> data, this.pedidoID) {
    cliente = Cliente.fromPedidos(data);
    estado = data['estado'] as String;
    fecha = data['fecha'] as Timestamp;
    pagado = data['pagado'] as bool;
    productos = getProductosList(data['productos'] as List);
    total = data['total'].toDouble() as double;
  }
  Pedido.fromPedidos(Map<String, dynamic> data, this.pedidoID) {
    cliente = Cliente.fromPedidos(data);
    estado = data['estado'] as String;
    fecha = data['fecha'] as Timestamp;
    pagado = data['pagado'] as bool;
    productos = getProductosList(data['productos']);
    total = data['total'].toDouble() as double;
  }

  List getProductosList(List list) {
    final List _list = [];
    for (var detalle in list) {
      _list.add(Detalle.fromGetPedidos(detalle));
    }
    return _list;
  }
}

class Detalle {
  int cantidad;
  String descripcion;
  String productoID;
  double precio;
  int stockActual;

  Detalle({
    this.cantidad,
    this.descripcion,
    this.productoID,
    this.precio,
    this.stockActual,
  });

  Detalle.fromGetPedidos(Map<String, dynamic> data) {
    cantidad = data['cantidad'] as int;
    descripcion = data['descripcion'] as String;
    productoID = data['productoID'] as String;
    precio = data['precio'].toDouble() as double;
  }

  Detalle.fromUpdateCarrito(
      Producto producto, this.cantidad, this.stockActual) {
    descripcion = producto.descripcion;
    precio = producto.precio;
    productoID = producto.productoID;
  }

  Map<String, dynamic> toFirebase() => {
        'cantidad': cantidad,
        'descripcion': descripcion,
        'productoID': productoID,
        'precio': precio
      };
}

class EstadoEntrega {
  List entrega;

  EstadoEntrega.fromMap(List data) {
    entrega = _getEstados(data);
  }

  List _getEstados(List data) {
    final List _list = [];
    for (var ent in data) {
      _list.add(ent);
    }
    return _list;
  }
}
