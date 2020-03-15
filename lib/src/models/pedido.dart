import 'package:cloud_firestore/cloud_firestore.dart';

enum Estado {
  PAGADO, NOPAGADO
}


class Pedido{

  String idPedido;
  String cliente;
  Timestamp fecha;
  double total;
  Estado estado;
  List detallePedido;

  Pedido({
    this.idPedido,
    this.cliente,
    this.fecha,
    this.total,
    this.estado,
    this.detallePedido,
  });

  
}