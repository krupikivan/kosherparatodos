import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/bloc/bloc.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

import '../show_toast.dart';

class ProductoItemWidget extends StatefulWidget {
  final Producto producto;

  ProductoItemWidget({Key key, this.producto}) : super(key: key);

  @override
  _ProductoItemWidgetState createState() => _ProductoItemWidgetState();
}

class _ProductoItemWidgetState extends State<ProductoItemWidget> {
  bool _isPressed = false;
  int _cantidad = 0;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: MyTheme.Colors.productos[0],
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkWell(
                onTap: toggleProductAdder,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(20)),
                      color: Colors.white30),
                  child: Center(
                      child: _isPressed
                          ? Icon(Icons.remove)
                          : Text(
                              '+',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.w100),
                            )),
                  height: 45,
                  width: 45,
                  // color: Colors.white30,
                ),
              )
            ],
          ),
          _isPressed
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Center(
                        child: Column(
                          // crossAxisAlignment: ,
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
                                        color: MyTheme.darken(
                                            MyTheme.Colors.productos[0], 0.4))),
                                child: Icon(Icons.add,
                                    color: MyTheme.darken(
                                        MyTheme.Colors.productos[0], 0.4))),
                            SizedBox(
                              height: 20,
                            ),
                            Text(_cantidad.toString(),
                                style: TextStyle(
                                    color: MyTheme.darken(
                                        MyTheme.Colors.productos[0], 0.4),
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 20,
                            ),
                            RawMaterialButton(
                                onPressed: () {
                                  setState(() {
                                    if (_cantidad > 0) _cantidad--;
                                  });
                                },
                                shape: CircleBorder(
                                    side: BorderSide(
                                        color: MyTheme.darken(
                                            MyTheme.Colors.productos[0], 0.4))),
                                child: Icon(
                                  Icons.remove,
                                  color: MyTheme.darken(
                                      MyTheme.Colors.productos[0], 0.4),
                                )),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: RawMaterialButton(
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
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/add-bag.png',
                                height: 20,
                                width: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'Agregar',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ))
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Image.network(widget.producto.imagen),
                          Text(
                            widget.producto.descripcion,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 20),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "\$${widget.producto.precio}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20),
                              )
                            ],
                          ),
                          Image.asset(
                            'assets/images/info.png',
                            height: 25,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
        ],
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
