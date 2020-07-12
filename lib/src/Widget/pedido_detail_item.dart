import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/models/pedido.dart';

class PedidoDetailItem extends StatelessWidget {
  const PedidoDetailItem({Key key, this.detalle}) : super(key: key);

  final Detalle detalle;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 30,
        child: Row(
          children: <Widget>[
            Text(
              detalle.cantidad.toString(),
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'x',
              style: TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
      title: Text(detalle.descripcion),
      subtitle: Text(detalle.marca),
      trailing: Text('\$${detalle.precio.truncate()}'),
    );
  }
}
