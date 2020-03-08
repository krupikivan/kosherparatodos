import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/models/product.dart';

class ItemCard extends StatelessWidget {
  ItemCard({Key key, @required this.item}) : super(key: key);
  final Producto item;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Image.network(item.image, fit: BoxFit.cover,),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(10),
    );
  }
}