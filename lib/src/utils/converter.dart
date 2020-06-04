import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Convert{

  getFechaFromTimestamp(Timestamp fecha){
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(fecha.millisecondsSinceEpoch);
    return DateFormat("dd/MM/yyyy").format(date);
  }
}

final convert = Convert();