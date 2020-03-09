import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/new_item_widget.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/models/product.dart';
import 'package:kosherparatodos/src/pages/home_pages/bloc/new_pedido_bloc.dart';
import 'package:kosherparatodos/src/pages/home_pages/bloc/product_data_bloc.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;
class NewPedidoPage extends StatefulWidget {
  const NewPedidoPage({Key key}) : super(key: key);

  @override
  _NewPedidoPageState createState() => _NewPedidoPageState();
}

class _NewPedidoPageState extends State<NewPedidoPage> {

  // TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // Producto _mySelection;
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
        onPressed: () => _displayDialog(context),
      ),
    );
  }


  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Agregar producto'),
            content: new SingleChildScrollView(
              child: new Material(
                child: new MyDialogContent()
              )
            ),
            actions: <Widget>[
              Center(
                child: new FlatButton(
                  child: new Text('Aceptar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              )
            ],
          );
        });
  }
}

class MyDialogContent extends StatefulWidget{
  @override
  _MyDialogContentState createState() => new _MyDialogContentState();
}
class _MyDialogContentState extends State<MyDialogContent>{

  TextEditingController _textFieldController = TextEditingController();
  Producto _mySelection;
  @override
  Widget build(BuildContext context) {
    return Column(
              children: <Widget>[
                TextField(
                  controller: _textFieldController,
                  decoration: InputDecoration(hintText: "Ingrese cantidad"),
                ),
                StreamBuilder<List<Producto>>(
                  stream: blocProductData.getProducts,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Text('Cargando...');
                    return DropdownButton<Producto>(
                      items: snapshot.data
                          .map((product) => DropdownMenuItem<Producto>(
                                child: Text(product.name),
                                value: product,
                              ))
                          .toList(),
                      onChanged: (Producto value) {
                        setState(() {
                          _mySelection = value;
                        });
                      },
                      value: _mySelection,
                      isExpanded: false,
                      hint: Text("Seleccionar"),
                    );
                  },
                )
              ],
            );
  }

}