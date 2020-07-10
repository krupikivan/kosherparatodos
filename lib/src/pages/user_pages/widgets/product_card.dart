import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/bloc/bloc.dart';

import '../../../Widget/export.dart';

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
      margin: EdgeInsets.symmetric(horizontal: 20),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      semanticContainer: true,
      elevation: 3,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Stack(
        children: <Widget>[
          _isPressed
              ? Row(
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            height: 82,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                RawMaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        if (_cantidad > 0) _cantidad--;
                                      });
                                    },
                                    shape: CircleBorder(
                                        side: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    child: Icon(
                                      Icons.remove,
                                      color: Theme.of(context).primaryColor,
                                    )),
                                Text(_cantidad.toString(),
                                    style: TextStyle(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold)),
                                RawMaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        _cantidad++;
                                      });
                                    },
                                    shape: CircleBorder(
                                        side: BorderSide(
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    child: Icon(Icons.add,
                                        color: Theme.of(context).primaryColor)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    RawMaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      fillColor: Theme.of(context).primaryColorLight,
                      elevation: 0,
                      onPressed: () {
                        blocPedidoVigente.updateCarrito(
                            widget.producto, _cantidad, widget.producto.stock);
                        _showMessage('Agregado al carrito');
                        _isPressed = false;
                        setState(() {});
                      },
                      child: Text(
                        'Agregar',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Align(alignment: Alignment.centerRight, child: _getIcon()),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(2, 2, 10, 2),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 78,
                            minHeight: 78,
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
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            FittedBox(
                              child: Text(
                                widget.producto.descripcion,
                                maxLines: 3,
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              '\$${widget.producto.precio.truncate()}',
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(alignment: Alignment.center, child: _getIcon()),
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
      fillColor: Theme.of(context).primaryColor,
      child: Icon(
        _isPressed ? Icons.remove : Icons.add,
        size: 20,
        color: Colors.white,
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
