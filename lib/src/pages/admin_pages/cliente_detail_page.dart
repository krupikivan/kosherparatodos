import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/cliente_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/pedido_notifier.dart';
import 'package:provider/provider.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class ClienteDetailPage extends StatelessWidget {
  @override
  Widget build(context) {
    ClienteNotifier cliente = Provider.of<ClienteNotifier>(context);
    // PedidoNotifier pedido = Provider.of<PedidoNotifier>(context);
    cliente.getPedidosCliente(Provider.of<PedidoNotifier>(context));
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: MyTheme.Colors.dark,
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: TitleText(
                text: 'Datos del cliente',
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(cliente.clienteActual.nombre),
                  leading: Icon(Icons.account_circle),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(cliente.clienteActual.email),
                  leading: Icon(Icons.email),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TitleText(
                text: 'Historial de pedidos',
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            Expanded(
              flex: 5,
              child: cliente.pedidoList.length == 0 ? Center(child: TitleText(text: 'No hay pedidos')) : ListView.builder(
                  itemCount: cliente.pedidoList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text('Total: ' +
                            cliente.pedidoList[index].total.toString()),
                        subtitle: Text(DateFormat("dd/MM/yyyy").format(cliente.pedidoList[index].fecha.toDate())),
                        trailing: Icon(
                          Icons.check_circle,
                          color:
                              cliente.pedidoList[index].pagado == true
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ),
                    );
                  }),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(color: MyTheme.Colors.dark),
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TitleText(
                      text:
                          'Cantidad de pedidos realizados:  ${cliente.pedidoList.length}',
                      color: MyTheme.Colors.minLight,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
