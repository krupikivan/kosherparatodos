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
            width: 45.0,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        DetallePedidoListPage()));
              },
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 10,
                    child: Image.asset(
                      'assets/icons/carrito_compras_50.png',
                      height: 35,
                      alignment: Alignment.center,
                    ),
                  ),
                  Positioned(
                      child: Stack(
                    children: <Widget>[
                      // Positioned(
                      //   bottom: 0,
                      //   child: Icon(Icons.brightness_1,
                      //       size: 20, color: Theme.of(context).primaryColor),
                      // ),
                      Positioned(
                          child: Center(
                        child: StreamBuilder<Pedido>(
                            stream: blocPedidoVigente.getPedido,
                            builder: (context, snapshot) {
                              return Text(
                                !snapshot.hasData ||
                                        snapshot.data.productos == null
                                    ? '0'
                                    : snapshot.data.productos.length.toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold),
                              );
                            }),
                      )),
                    ],
                  )),
                ],
              ),
            )));
  }
}
