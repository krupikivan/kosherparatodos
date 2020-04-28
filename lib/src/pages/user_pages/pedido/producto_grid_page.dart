import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/producto_item_widget.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

import 'bloc/bloc.dart';

class ProductoGridPage extends StatefulWidget {

  @override
  _ProductoGridPageState createState() => _ProductoGridPageState();
}

class _ProductoGridPageState extends State<ProductoGridPage> {

@override
void initState() { 
  super.initState();
  blocProductosFirebase.getProductosFirebase();
}

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: StreamBuilder<List<Producto>>(
            stream: blocProductosFirebase.getProductosVigentes,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                    child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(MyTheme.Colors.dark),
                ));
              else
                return GridView.builder(
                    itemCount: snapshot.data.length,
                    gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (BuildContext context, int index) {
                      return ProductoItemWidget(producto: snapshot.data[index]);
                    });
            }),
      );
  }
}
