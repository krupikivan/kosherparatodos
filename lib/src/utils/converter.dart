import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Convert {
  String getFechaFromTimestamp(Timestamp fecha) {
    final DateTime date =
        new DateTime.fromMillisecondsSinceEpoch(fecha.millisecondsSinceEpoch);
    return DateFormat("dd/MM/yyyy").format(date);
  }
}

final Convert convert = Convert();
