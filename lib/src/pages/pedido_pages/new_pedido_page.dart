import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/product_card_widget.dart';
import 'package:kosherparatodos/src/models/detalle_pedido.dart';
import 'package:kosherparatodos/src/models/product.dart';
import 'package:kosherparatodos/src/pages/home_pages/bloc/new_pedido_bloc.dart';
import 'package:kosherparatodos/src/pages/home_pages/bloc/product_data_bloc.dart';
import 'package:kosherparatodos/src/pages/pedido_pages/pedido_cart.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class NewPedidoPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.Colors.dark,
        title: Text("Nuevo pedido"),
        actions: <Widget>[
          // IconButton(
          //     onPressed: ()=> null, icon: Icon(Icons.shop),
          //   )
          new Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Container(
                  height: 150.0,
                  width: 30.0,
                  child: new GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          new MaterialPageRoute(
                              builder:(BuildContext context) =>
                              new PedidoCart()
                          )
                      );
                    },
                    child: new Stack(
                      children: <Widget>[
                        new IconButton(
                          icon: new Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                          onPressed: null,
                        ),
                        new Positioned(
                            child: new Stack(
                          children: <Widget>[
                            new Icon(Icons.brightness_1,
                                size: 20.0, color: Colors.green[800]),
                            new Positioned(
                                top: 3.0,
                                right: 4.0,
                                child: new Center(
                                  child: StreamBuilder<List<DetallePedido>>(
                                      stream: blocNewPedido.getDetalleList,
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData)
                                          return Text('0');
                                        else
                                          return new Text(
                                            snapshot.data.
                                                length.toString(),
                                            style: new TextStyle(
                                                color: Colors.white,
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.w500),
                                          );
                                      }),
                                )),
                          ],
                        )),
                      ],
                    ),
                  ))),
        ],
      ),
      body: Container(
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
      ),
    );
  }
}
