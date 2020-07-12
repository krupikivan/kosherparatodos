import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'cliente.dart';

enum EnumEntrega { EnPreparacion, Entregado, Cancelado }

class Pedido {
  String pedidoID;
  bool envio;
  int costoEnvio;
  Cliente cliente;
  EnumEntrega estadoEntrega;
  Timestamp fecha;
  bool pagado;
  List productos;
  double total;

  Pedido({
    this.pedidoID,
    this.envio,
    this.costoEnvio,
    this.cliente,
    this.estadoEntrega,
    this.fecha,
    this.pagado,
    this.total,
    this.productos,
  });

  Pedido.fromFirebase(Map<String, dynamic> data, this.pedidoID) {
    cliente = Cliente.fromPedidos(data);
    envio = data['envio'] as bool;
    costoEnvio = data['costoEnvio'] as int;
    estadoEntrega = stringToEnumEntrega(data['estado']);
    fecha = data['fecha'] as Timestamp;
    pagado = data['pagado'] as bool;
    productos = getProductosList(data['productos'] as List);
    total = data['total'].toDouble() as double;
  }
  Pedido.fromPedidos(Map<String, dynamic> data, this.pedidoID) {
    cliente = Cliente.fromPedidos(data);
    envio = data['envio'] as bool;
    costoEnvio = data['costoEnvio'] as int;
    estadoEntrega = stringToEnumEntrega(data['estado']);
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

  static String enumEntregaToString(EnumEntrega val) {
    switch (val) {
      case EnumEntrega.EnPreparacion:
        return 'En Preparacion';
        break;
      case EnumEntrega.Entregado:
        return 'Entregado';
        break;
      case EnumEntrega.Cancelado:
        return 'Cancelado';
        break;
      default:
        return null;
    }
  }

  static String getPagado(bool pagado) {
    if (pagado) {
      return 'Pagado';
    } else {
      return 'No Pagado';
    }
  }

  static EnumEntrega stringToEnumEntrega(String val) {
    switch (val) {
      case 'En Preparacion':
        return EnumEntrega.EnPreparacion;
        break;
      case 'Entregado':
        return EnumEntrega.Entregado;
        break;
      case 'Cancelado':
        return EnumEntrega.Cancelado;
        break;
      default:
        return null;
    }
  }

  static MaterialColor getEstadoColor(String estado) {
    switch (estado) {
      case 'Entregado':
        return Colors.green;
        break;
      case 'En Preparacion':
        return Colors.orange;
        break;
      case 'Cancelado':
        return Colors.red;
        break;
      default:
        return Colors.green;
    }
  }

  static MaterialColor getPagadoColor(bool pagado) {
    switch (pagado) {
      case true:
        return Colors.green;
        break;
      case false:
        return Colors.red;
        break;
      default:
        return Colors.red;
    }
  }
}

class Detalle {
  int cantidad;
  String descripcion;
  String productoID;
  double precio;
  String marca;
  int stockActual;

  Detalle({
    this.cantidad,
    this.descripcion,
    this.marca,
    this.productoID,
    this.precio,
    this.stockActual,
  });

  Detalle.fromGetPedidos(Map<String, dynamic> data) {
    cantidad = data['cantidad'] as int;
    descripcion = data['descripcion'] as String;
    marca = data['marca'] as String;
    productoID = data['productoID'] as String;
    precio = data['precio'].toDouble() as double;
  }

  Detalle.fromUpdateCarrito(
      Producto producto, this.cantidad, this.stockActual) {
    descripcion = producto.descripcion;
    marca = producto.marca;
    precio = producto.precio;
    productoID = producto.productoID;
  }

  Map<String, dynamic> toFirebase() => {
        'cantidad': cantidad,
        'descripcion': descripcion,
        'marca': marca,
        'productoID': productoID,
        'precio': precio
      };
}

class EstadoEntrega {
  List<EnumEntrega> entrega;

  EstadoEntrega.fromMap(List data) {
    entrega = _getEstados(data);
  }

  List<EnumEntrega> _getEstados(List data) {
    final List<EnumEntrega> _list = [];
    for (var ent in data) {
      _list.add(Pedido.stringToEnumEntrega(ent));
    }
    return _list;
  }
}
