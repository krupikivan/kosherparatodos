import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kosherparatodos/src/models/cliente.dart';

enum Estado {
  PAGADO, NOPAGADO
}


class Pedido{

  String idPedido;
  Cliente cliente;
  Timestamp fecha;
  double total;
  Estado pagado;
  String estado;
  List detallePedido;

  Pedido({
    this.idPedido,
    this.cliente,
    this.fecha,
    this.total,
    this.pagado,
    this.estado,
    this.detallePedido,
  });

  Pedido.fromMap(Map<String, dynamic> data, id, clie){
    idPedido = id;
    cliente = clie;
    fecha = data['fecha'];
    estado = data['estado'];
    total = data['total'].toDouble();
    pagado = data['pagado'] == true ? Estado.PAGADO : Estado.NOPAGADO;
  }
  
}