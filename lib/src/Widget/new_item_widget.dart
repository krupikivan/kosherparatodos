import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/models/detalle_pedido.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class NewItemWidget extends StatelessWidget {
  const NewItemWidget({Key key, this.item}) : super(key: key);
  final DetallePedido item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(item.name),
          Text(item.cantidad.toString()),
          Text('\$${item.total}'),
          // ListTile(
          //     title: Text(item.name),
          //     subtitle: Row(
          //       children: <Widget>[
          //         Text('\$${item.total} '),
          //       ],
          //     ),
          //     trailing: Container(
          //       width: 35,
          //       height: 35,
          //       alignment: Alignment.center,
          //       child: Text('\$${item.total}'),
          //     )),
        ],
      ),
    );
  }
}
