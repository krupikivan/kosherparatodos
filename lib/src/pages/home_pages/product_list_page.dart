import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/item_card_widget.dart';
import 'package:kosherparatodos/src/models/product.dart';
import 'package:kosherparatodos/src/pages/home_pages/bloc/product_data_bloc.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class ProductListPage extends StatefulWidget {
  const ProductListPage({Key key}) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {

@override
void initState() {
    blocProductData.getProductList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Producto>>(
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
                return ItemCard(item: snapshot.data[index]);
              },
            );
        });
  }
}
