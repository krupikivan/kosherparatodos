import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';

class BottomPedidoTotal extends StatelessWidget {
  const BottomPedidoTotal({Key key, this.total}) : super(key: key);

  final double total;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: new Border.all(
              color: Theme.of(context).primaryColor,
              width: 2.0,
              style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TitleText(
            text: 'Total',
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          TitleText(
            color: Colors.white,
            text: '\$${total.truncate()}',
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}
