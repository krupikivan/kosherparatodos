import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/export.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/widgets/export.dart';
import 'package:kosherparatodos/src/pages/user_pages/widgets/item_detalle_pedido_widget.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/bloc/bloc.dart';
import 'package:kosherparatodos/src/providers/data_provider.dart';
import 'package:kosherparatodos/src/utils/show_messages.dart';
import 'package:provider/provider.dart';

class DetallePedidoListPage extends StatefulWidget {
  @override
  _DetallePedidoListPageState createState() => _DetallePedidoListPageState();
}

class _DetallePedidoListPageState extends State<DetallePedidoListPage> {
  bool _envio;

  @override
  void initState() {
    super.initState();
    _envio = false;
  }

  Widget _addHeader(context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            TitlePedidoDetail(text: 'Producto', context: context),
            TitlePedidoDetail(text: 'Precio Unitario', context: context),
          ],
        ),
      ),
    );
  }

  Widget _productItems() {
    return Expanded(
      flex: 4,
      child: StreamBuilder<Pedido>(
          stream: blocPedidoVigente.getPedido,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data.productos == null)
              return EmptyData(text: 'Vacio');
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
                        initialData: false,
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
            StreamBuilder<Pedido>(
              stream: blocPedidoVigente.getPedido,
              builder: (context, snapshot) => !snapshot.hasData ||
                      snapshot.data.total == null
                  ? SizedBox()
                  : Consumer<DataProvider>(
                      builder: (context, data, _) => data == null
                          ? SizedBox()
                          : Row(
                              children: <Widget>[
                                TotalPedido(total: snapshot.data.total),
                                Column(
                                  children: <Widget>[
                                    ChoiceChip(
                                      selected: _envio,
                                      selectedColor:
                                          Theme.of(context).primaryColor,
                                      label:
                                          Text('Envio: \$${data.costoEnvio}'),
                                      labelStyle: TextStyle(
                                        color: _envio
                                            ? Colors.white
                                            : Theme.of(context).primaryColor,
                                      ),
                                      onSelected: (nopagado) =>
                                          _changeBool(data.costoEnvio),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ),
            ),
            SizedBox(height: 30),
            _realizarPedido(context),
          ],
        ),
      ),
    );
  }

  void _changeBool(int costo) {
    if (_envio) {
      _envio = false;
      setState(() {});
    } else {
      _envio = true;
      setState(() {});
    }
    blocPedidoVigente.updateEnvioPedido(_envio, costo);
  }
}
