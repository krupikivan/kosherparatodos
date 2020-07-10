import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/bloc/bloc.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/pedido.dart';

class IconCart extends StatelessWidget {
  final BuildContext context;

  const IconCart({Key key, this.context}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
            height: 150.0,
            width: 30.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        DetallePedidoListPage()));
              },
              child: Stack(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: null,
                  ),
                  Positioned(
                      child: Stack(
                    children: <Widget>[
                      Icon(Icons.brightness_1,
                          size: 20.0, color: Theme.of(context).primaryColor),
                      Positioned(
                          top: 3.0,
                          right: 4.0,
                          child: Center(
                            child: StreamBuilder<Pedido>(
                                stream: blocPedidoVigente.getPedido,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData ||
                                      snapshot.data.productos == null) {
                                    return const Text('0');
                                  } else {
                                    return Text(
                                      snapshot.data.productos.length.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.0,
                                          fontWeight: FontWeight.w500),
                                    );
                                  }
                                }),
                          )),
                    ],
                  )),
                ],
              ),
            )));
  }
}
