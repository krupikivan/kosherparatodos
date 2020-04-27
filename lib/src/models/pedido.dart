import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kosherparatodos/src/models/cliente.dart';
import 'package:kosherparatodos/src/models/detalle_pedido.dart';

enum Estado {
  PAGADO, NOPAGADO
}


class Pedido{

  String idPedido;
  Cliente cliente;
  Timestamp fecha;
  var total;
  Estado pagado;
  String estado;
  List<DetallePedido> detallePedido;

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
    cliente = Cliente.fromMap(clie, data['cliente']);
    fecha = data['fecha'];
    estado = data['estado'];
    total = data['total'].toDouble();
    pagado = data['pagado'] == true ? Estado.PAGADO : Estado.NOPAGADO;
  }
  
}