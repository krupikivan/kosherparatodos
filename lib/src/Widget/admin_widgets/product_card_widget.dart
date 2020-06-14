import 'package:flutter/material.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class ProductCardWidget extends StatelessWidget {
  final String descripcion;
  final String img;
  final double elevation;
  final Color color;
  final VoidCallback action;
  const ProductCardWidget(
      {Key key,
      this.descripcion,
      this.action,
      this.img,
      this.elevation,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? MyTheme.Colors.white,
      elevation: elevation ?? 10,
      shadowColor: Colors.black38,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(
          descripcion,
          style: TextStyle(fontSize: 15),
        ),
        leading: Image.network(img),
        onTap: action,
      ),
    );
  }
}
