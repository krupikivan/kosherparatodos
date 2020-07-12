import 'package:flutter/material.dart';

class TitlePedidoDetail extends StatelessWidget {
  const TitlePedidoDetail({Key key, this.text, this.context}) : super(key: key);
  final String text;
  final BuildContext context;
  @override
  Widget build(context) {
    return Text(text,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor));
  }
}
