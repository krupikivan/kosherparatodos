import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/pedido.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class ProductoItemWidget extends StatefulWidget {
  final Producto producto;

  ProductoItemWidget({Key key, this.producto}) : super(key: key);

  @override
  _ProductoItemWidgetState createState() => _ProductoItemWidgetState();
}

class _ProductoItemWidgetState extends State<ProductoItemWidget> {
  bool _isPressed = false;
  int _text = 0;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => new ProductoItemDetalle(
                  producto: widget.producto,
                )));
      },
      child: Card(
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
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20)),
                          color: Colors.white30),
                      child: Center(
                          child: _isPressed
                              ? Icon(Icons.remove)
                              : Text(
                                  '+',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w100),
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
                                        _text++;
                                      });
                                    },
                                    shape: CircleBorder(
                                        side: BorderSide(
                                            color: MyTheme.darken(MyTheme.Colors.productos[0], 0.4))),
                                    child: Icon(Icons.add,
                                        color: MyTheme.darken(MyTheme.Colors.productos[0], 0.4))),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(_text.toString(),
                                    style: TextStyle(
                                        color: MyTheme.darken(MyTheme.Colors.productos[0], 0.4),
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 20,
                                ),
                                RawMaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        if (_text > 0) _text--;
                                      });
                                    },
                                    shape: CircleBorder(
                                        side: BorderSide(
                                            color: MyTheme.darken(MyTheme.Colors.productos[0], 0.4))),
                                    child: Icon(
                                      Icons.remove,
                                      color: MyTheme.darken(MyTheme.Colors.productos[0], 0.4),
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
                              onPressed: () => {
                                //TODO: ACA SE MANDA EL CONTENIDO DEL TEXT AL STREAM PARA QUE SE ACTUALIZE EN EL CARRITO
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/add-bag.png', height: 20, width: 20,),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'Agregar',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
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
                              Image.asset('assets/images/Carne-10.png'),
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
                                        fontWeight: FontWeight.w600,
                                        fontSize: 20),
                                  ),
                                  Text(
                                    widget.producto.descripcion,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12),
                                  ),
                                ],
                              ),
                              Image.asset('assets/images/info.png', height: 25,)
                            ],
                          ),
                        ],
                      ),
                    )
          ],
        ),
      ),
    );
  }

  void toggleProductAdder() {
    setState(() {
      if (_isPressed == false) {
        _text = 0;
        _isPressed = true;
      } else {
        _text = 0;
        _isPressed = false;
      }
    });
  }

}