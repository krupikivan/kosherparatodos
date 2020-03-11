import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/models/detalle_pedido.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class NewItemWidget extends StatelessWidget {
  const NewItemWidget({Key key, this.item}) : super(key: key);
  final DetallePedido item;

  @override
  Widget build(BuildContext context) {
    return ListTile(
                  title: Text(item.name),
                  subtitle: Row(
                    children: <Widget>[
                      Text('\$ '),
                    ],
                  ),
                  trailing: Container(
                    width: 35,
                    height: 35,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: MyTheme.Colors.light,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text('${item.cantidad}'),
                  ));
  }
}