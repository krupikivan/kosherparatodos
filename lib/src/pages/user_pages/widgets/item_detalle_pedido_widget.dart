import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/bloc/bloc.dart';

class ItemDetallePedidoWidget extends StatelessWidget {
  const ItemDetallePedidoWidget({Key key, this.item}) : super(key: key);
  final Detalle item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListTile(
          leading: IconButton(
            icon: Icon(Icons.remove),
            onPressed: () => blocPedidoVigente.removeOnPedido(item),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(item.descripcion),
              Text(item.marca),
            ],
          ),
          subtitle: Text('${item.cantidad} unid.'),
          isThreeLine: true,
          trailing: Container(
            width: 70,
            height: 70,
            alignment: Alignment.center,
            child: Text('\$${item.precio.truncate()}'),
          )),
    );
  }
}
