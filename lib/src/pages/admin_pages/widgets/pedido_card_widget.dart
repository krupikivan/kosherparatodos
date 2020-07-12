import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/models/pedido.dart';

class PedidoCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String estado;
  final bool envio;
  final bool pagado;
  final double elevation;
  final Color color;
  final VoidCallback action;
  const PedidoCardWidget(
      {Key key,
      this.action,
      this.elevation,
      this.color,
      this.title,
      this.subtitle,
      this.estado,
      this.pagado,
      this.envio})
      : super(key: key);
// convert.getFechaFromTimestamp(fecha)
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Card(
        shadowColor: Colors.black38,
        color: color ?? Colors.white,
        elevation: elevation ?? 10,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Theme.of(context).cardColor)),
        child: ListTile(
          title: Text(
            title,
            style: const TextStyle(fontSize: 15),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                Icons.local_shipping,
                size: 20,
                color: envio ? Colors.green : Colors.red,
              ),
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.watch_later,
                size: 20,
                color: Pedido.getEstadoColor(estado),
              ),
              SizedBox(
                width: 20,
              ),
              Icon(
                Icons.payment,
                size: 20,
                color: Pedido.getPagadoColor(pagado),
              ),
            ],
          ),
          subtitle: Text(subtitle),
          onTap: action,
        ),
      ),
    );
  }
}
