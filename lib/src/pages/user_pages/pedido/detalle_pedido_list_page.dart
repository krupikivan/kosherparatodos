import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/item_detalle_pedido_widget.dart';
import 'package:kosherparatodos/src/Widget/show_toast.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/bloc/bloc.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class DetallePedidoListPage extends StatelessWidget {
  Widget _addHeader() {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _getRowText('Producto'),
            _getRowText('Precio Unitario')
          ],
        ),
      ),
    );
  }

  Widget _getRowText(String text) {
    return Text(text,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500));
  }

  Widget _productItems() {
    return Expanded(
      flex: 4,
      child: StreamBuilder<Pedido>(
          stream: blocPedidoVigente.getPedido,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data.productos == null)
              return _noHayPedidos();
            else
              return ListView.builder(
                itemCount: snapshot.data.productos.length,
                itemBuilder: (BuildContext context, int index) {
                  return ItemDetallePedidoWidget(
                    item: snapshot.data.productos[index],
                  );
                },
              );
          }),
    );
  }

  Widget _noHayPedidos() {
    return Container(
      child: const Center(
          child: Text(
        'No tiene pedidos',
        style: TextStyle(fontSize: 20),
      )),
    );
  }

  Widget _getTotal() {
    return Expanded(
      flex: 2,
      child: StreamBuilder<Pedido>(
        stream: blocPedidoVigente.getPedido,
        builder: (context, snapshot) =>
            !snapshot.hasData || snapshot.data.total == null
                ? SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TitleText(
                        text:
                            'Total del pedido: \$${snapshot.data.total.truncate().toString()}',
                        color: MyTheme.Colors.accent,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _realizarPedido(BuildContext context) {
    return StreamBuilder<Pedido>(
        stream: blocPedidoVigente.getPedido,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            return snapshot.data.total == null
                ? SizedBox()
                : Column(
                    children: [
                      FlatButton(
                          onPressed: () {
                            if (snapshot.data.total != 0.0) {
                              blocPedidoVigente.realizarPedido();
                              ShowToast().show('Exito!', 5);
                            } else {
                              ShowToast().show('El pedido esta vacio', 5);
                            }
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: MyTheme.Colors.accent,
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              snapshot.data.pedidoID == null
                                  ? 'Realizar pedido'
                                  : 'Modificar pedido',
                              style: TextStyle(color: MyTheme.Colors.white),
                            ),
                          )),
                      FlatButton(
                          onPressed: () => blocPedidoVigente.clearPedido(),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: MyTheme.Colors.accent,
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'Cancelar',
                              style: TextStyle(color: MyTheme.Colors.white),
                            ),
                          )),
                    ],
                  );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.Colors.accent,
        title: Text("Detalle del Pedido"),
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
            _getTotal(),
            SizedBox(height: 30),
            _realizarPedido(context),
          ],
        ),
      ),
    );
  }
}
