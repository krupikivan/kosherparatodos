import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/bloc/bloc.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

import 'export.dart';

class ProductoCard extends StatefulWidget {
  ProductoCard({Key key, this.producto, this.imagen}) : super(key: key);
  final Producto producto;
  final String imagen;

  @override
  _ProductoCardState createState() => _ProductoCardState();
}

class _ProductoCardState extends State<ProductoCard> {
  bool _isPressed = false;
  int _cantidad = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      semanticContainer: true,
      elevation: 10,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Stack(
        children: <Widget>[
          Align(alignment: Alignment.topRight, child: _getIcon()),
          _isPressed
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          RawMaterialButton(
                              onPressed: () {
                                setState(() {
                                  _cantidad++;
                                });
                              },
                              shape: CircleBorder(
                                  side: BorderSide(
                                      color: MyTheme.Colors.primary)),
                              child: Icon(Icons.add,
                                  color: MyTheme.Colors.primary)),
                          Text(_cantidad.toString(),
                              style: TextStyle(
                                  color: MyTheme.Colors.primary,
                                  fontWeight: FontWeight.bold)),
                          RawMaterialButton(
                              onPressed: () {
                                setState(() {
                                  if (_cantidad > 0) _cantidad--;
                                });
                              },
                              shape: CircleBorder(
                                  side: BorderSide(
                                      color: MyTheme.Colors.primary)),
                              child: Icon(
                                Icons.remove,
                                color: MyTheme.Colors.primary,
                              )),
                        ],
                      ),
                      RawMaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        fillColor: Colors.white,
                        elevation: 0,
                        onPressed: () {
                          blocPedidoVigente.updateCarrito(widget.producto,
                              _cantidad, widget.producto.stock);
                          _showMessage('Agregado al carrito');
                          _isPressed = false;
                          setState(() {});
                        },
                        child: Text(
                          'Agregar',
                          style: TextStyle(
                              color: MyTheme.Colors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ))
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FittedBox(
                              child: Text(
                                widget.producto.descripcion,
                                maxLines: 3,
                                style: TextStyle(
                                    color: MyTheme.Colors.primary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              '\$${widget.producto.precio.truncate()}',
                              style: TextStyle(
                                  color: MyTheme.Colors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 80,
                            minHeight: 80,
                          ),
                          child: Hero(
                            tag: widget.producto.descripcion,
                            child: Image(
                              image: NetworkImage(widget.imagen),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _getIcon() {
    return RawMaterialButton(
      onPressed: toggleProductAdder,
      shape: CircleBorder(),
      fillColor: MyTheme.Colors.primary,
      child: Icon(
        _isPressed ? Icons.remove : Icons.add,
        size: 20,
        color: MyTheme.Colors.white,
      ),
    );
  }

  _showMessage(String msg) {
    ShowToast().show(msg, 5);
  }

  void toggleProductAdder() {
    setState(() {
      if (_isPressed == false) {
        _cantidad = 0;
        _isPressed = true;
      } else {
        _cantidad = 0;
        _isPressed = false;
      }
    });
  }
}
