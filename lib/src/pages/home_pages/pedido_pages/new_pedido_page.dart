import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/product_card_widget.dart';
import 'package:kosherparatodos/src/models/product.dart';
import 'package:kosherparatodos/src/pages/home_pages/bloc/product_data_bloc.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class NewPedidoPage extends StatefulWidget {

  @override
  _NewPedidoPageState createState() => _NewPedidoPageState();
}

class _NewPedidoPageState extends State<NewPedidoPage> {

@override
void initState() { 
  super.initState();
  blocProductData.getProductList();
}

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(10),
        child: StreamBuilder<List<Producto>>(
            stream: blocProductData.getProducts,
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
                      return ProductCardWidget(producto: snapshot.data[index]);
                    });
            }),
      );
  }
}
