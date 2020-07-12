import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kosherparatodos/src/models/pedido.dart';

class HistorialDetailInfoCard extends StatelessWidget {
  const HistorialDetailInfoCard({Key key, this.pedido}) : super(key: key);
  final Pedido pedido;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).backgroundColor,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
                leading: Icon(
                  Icons.watch_later,
                  color: Pedido.getEstadoColor(
                      Pedido.enumEntregaToString(pedido.estadoEntrega)),
                ),
                title: Text(
                    'Estado: ${Pedido.enumEntregaToString(pedido.estadoEntrega)}')),
            ListTile(
                leading: Icon(
                  Icons.payment,
                  color: Pedido.getPagadoColor(pedido.pagado),
                ),
                title: Text(Pedido.getPagado(pedido.pagado))),
            ListTile(
                leading: Icon(
                  Icons.local_shipping,
                  color: pedido.envio ? Colors.green : Colors.red,
                ),
                title: Text(pedido.envio
                    ? 'Su pedido tiene envio: \$${pedido.costoEnvio}'
                    : 'Su pedido no tiene envio')),
          ],
        ),
      ),
    );
  }
}
