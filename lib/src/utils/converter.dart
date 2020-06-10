import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:kosherparatodos/src/models/pedido.dart';

class Convert {
  String getFechaFromTimestamp(Timestamp fecha) {
    final DateTime date =
        new DateTime.fromMillisecondsSinceEpoch(fecha.millisecondsSinceEpoch);
    return DateFormat("dd/MM/yyyy").format(date);
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
}

final Convert convert = Convert();
