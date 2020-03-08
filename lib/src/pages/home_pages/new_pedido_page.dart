import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/new_item_widget.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/models/product.dart';
import 'package:kosherparatodos/src/pages/home_pages/bloc/new_pedido_bloc.dart';
import 'package:kosherparatodos/src/pages/home_pages/bloc/product_data_bloc.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;
import 'package:rflutter_alert/rflutter_alert.dart';

class NewPedidoPage extends StatefulWidget {
  const NewPedidoPage({Key key}) : super(key: key);

  @override
  _NewPedidoPageState createState() => _NewPedidoPageState();
}

class _NewPedidoPageState extends State<NewPedidoPage> {
  @override
  void initState() {
    super.initState();
    blocProductData.getProductList();
    list = new List<Producto>();
  }

  String _mySelection;
  List<Producto> list;

  Widget _productItems() {
    return StreamBuilder<Pedido>(
        stream: blocNewPedido.getPedido,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
                child: Center(
              child: Text('No hay pedido'),
            ));
          else
            return Expanded(
              child: ListView.builder(
                itemCount: snapshot.data.detallePedido.length,
                itemBuilder: (BuildContext context, int index) {
                  return NewItemWidget(
                    item: snapshot.data.detallePedido[index],
                  );
                },
              ),
            );
        });
  }

  Widget _price() {
    return StreamBuilder<Pedido>(
        stream: blocNewPedido.getPedido,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
                child: Center(
              child: Text('\$0'),
            ));
          else
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Total a pagar: \$${snapshot.data.total}'),
              ],
            );
        });
  }

  Widget _submitButton(BuildContext context) {
    return FlatButton(
        onPressed: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        color: MyTheme.Colors.dark,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Text(
            'Realizar pedido',
            style: TextStyle(color: MyTheme.Colors.light),
          ),
        ));
  }

  double getPrice() {
    double price = 0;
    // AppData.cartList.forEach((x) {
    //   price += x.price * x.id;
    // });
    return price;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.Colors.dark,
        title: Text("Nuevo pedido"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            _productItems(),
            Divider(
              thickness: 1,
              height: 70,
            ),
            _price(),
            SizedBox(height: 30),
            _submitButton(context),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: MyTheme.Colors.light,
        ),
        backgroundColor: MyTheme.Colors.dark,
        onPressed: () => _addPedido(context),
      ),
    );
  }

  _addPedido(context) {
    Alert(
        context: context,
        title: "Agregar",
        content: Column(
          children: <Widget>[
            StreamBuilder<List<Producto>>(
                stream: blocProductData.getProducts,
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(
                        child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          MyTheme.Colors.dark),
                    ));
                  else
                    return DropdownButton(
                      items: snapshot.data.map((Producto item) {
                        return DropdownMenuItem<String>(
                          value: item.idProducto,
                          child: Text(item.name),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          _mySelection = newVal;
                        });
                      },
                      value: _mySelection,
                    );
                }),
          ],
        ),
        buttons: [
          DialogButton(
            color: MyTheme.Colors.dark,
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Agregar",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }
}
