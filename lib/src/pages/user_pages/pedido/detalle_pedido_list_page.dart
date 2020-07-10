import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/pages/user_pages/widgets/item_detalle_pedido_widget.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/bloc/bloc.dart';
import 'package:kosherparatodos/src/utils/show_messages.dart';

class DetallePedidoListPage extends StatelessWidget {
  Widget _addHeader(context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _getRowText('Producto', context),
            _getRowText('Precio Unitario', context)
          ],
        ),
      ),
    );
  }

  Widget _getRowText(String text, context) {
    return Text(text,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor));
  }

  Widget _productItems() {
    return Expanded(
      flex: 4,
      child: StreamBuilder<Pedido>(
          stream: blocPedidoVigente.getPedido,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data.productos == null)
              return _cleanCart();
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

  Widget _cleanCart() {
    return const Center(child: Text('Vacio', style: TextStyle(fontSize: 20)));
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
                        color: Theme.of(context).primaryColor,
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
                      StreamBuilder<bool>(
                        stream: blocPedidoVigente.getLoading,
                        builder: (context, load) => !load.data
                            ? FlatButton(
                                onPressed: () {
                                  if (snapshot.data.total != 0.0) {
                                    blocPedidoVigente.realizarPedido().then(
                                        (value) {
                                      Show('Realizando pedido');
                                      Show('Pedido realizado!');
                                    },
                                        onError: (onError) => Show(
                                            'No hay stock disponible')).whenComplete(
                                        () {
                                      blocPedidoVigente.clearPedido();
                                    });
                                  } else {
                                    Show('El pedido esta vacio');
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                color: Theme.of(context).primaryColor,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  child: Text(
                                    'Realizar pedido',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ))
                            : CircularProgressIndicator(),
                      ),
                      FlatButton(
                          onPressed: () => blocPedidoVigente.clearPedido(),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          color: Theme.of(context).primaryColor,
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              'Cancelar',
                              style: TextStyle(color: Colors.white),
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
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            _addHeader(context),
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
