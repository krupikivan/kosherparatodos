import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/export.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class BottomPedidoTotal extends StatelessWidget {
  const BottomPedidoTotal({Key key, this.total}) : super(key: key);

  final double total;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: MyTheme.Colors.primary,
          border: new Border.all(
              color: MyTheme.Colors.primary,
              width: 2.0,
              style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(25))),
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TitleText(
            text: 'Total',
            color: MyTheme.Colors.white,
            fontWeight: FontWeight.w500,
          ),
          TitleText(
            color: MyTheme.Colors.white,
            text: '\$${total.truncate()}',
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
