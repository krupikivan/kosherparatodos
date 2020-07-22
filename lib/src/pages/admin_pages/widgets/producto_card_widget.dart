import 'package:flutter/material.dart';

class ProductoCardWidget extends StatelessWidget {
  final String descripcion;
  final String marca;
  final String img;
  final double elevation;
  final Color color;
  final VoidCallback action;
  const ProductoCardWidget(
      {Key key,
      this.descripcion,
      this.marca,
      this.action,
      this.img,
      this.elevation,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      child: Card(
        color: color ?? Colors.white,
        elevation: elevation ?? 10,
        shadowColor: Colors.black38,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          title: Text(
            descripcion,
            style: TextStyle(fontSize: 15),
          ),
          subtitle: Text(
            marca,
            style: TextStyle(fontSize: 12),
          ),
          leading: CircleAvatar(
            child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 0),
                  color: Colors.white,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: img == ""
                          ? AssetImage('assets/images/logo.png')
                          : NetworkImage(img))),
            ),
          ),
          onTap: action,
        ),
      ),
    );
  }
}
