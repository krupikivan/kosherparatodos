import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/new_item_widget.dart';
import 'package:kosherparatodos/src/models/detalle_pedido.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/pages/home_pages/bloc/new_pedido_bloc.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class PedidoCart extends StatelessWidget {
  Widget _addHeader() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Producto'),
            Text('Cantidad'),
            Text('Total')
          ],
        ),
      ),
    );
  }

  Widget _productItems() {
    return StreamBuilder<List<DetallePedido>>(
        stream: blocNewPedido.getDetalleList,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
                child: Center(
              child: Text('No hay pedido'),
            ));
          else
            return Expanded(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return NewItemWidget(
                    item: snapshot.data[index],
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
            _addHeader(),
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
    );
  }
}