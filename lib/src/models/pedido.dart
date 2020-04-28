import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kosherparatodos/src/models/cliente.dart';
import 'package:kosherparatodos/src/models/detalle_pedido.dart';

enum Pagado { PAGADO, NOPAGADO }

enum Estado { CANCELADO, ENPROCESO, ENTREGADO }

class Pedido {
  String idPedido;
  Cliente cliente;
  Timestamp fecha;
  var total;
  Pagado pagado;
  Estado estado;
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

  Pedido.fromMap(Map<String, dynamic> data, id, clie) {
    idPedido = id;
    cliente = Cliente.fromMap(clie, data['cliente']);
    fecha = data['fecha'];
    estado = getEstado(data['estado']);
    total = data['total'].toDouble();
    pagado = data['pagado'] == true ? Pagado.PAGADO : Pagado.NOPAGADO;
  }

  String getEstadoString(Estado estado) {
    switch (estado) {
      case Estado.ENPROCESO:
        return "En proceso";
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
      case "En proceso":
        return Estado.ENPROCESO;
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
