import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/export.dart';

class TotalPedido extends StatelessWidget {
  const TotalPedido({Key key, this.total}) : super(key: key);
  final double total;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: TitleText(
        text: 'Total del pedido: \$${total.truncate().toString()}',
        color: Theme.of(context).primaryColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
