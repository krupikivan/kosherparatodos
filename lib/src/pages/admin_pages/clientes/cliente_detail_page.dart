import 'package:flutter/material.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
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
                ListTile(
                  title: Text(cliente.clienteActual.nombre.nombre +
                      ' ' +
                      cliente.clienteActual.nombre.apellido),
                  leading: Icon(Icons.account_circle),
                ),
                ListTile(
                  title: Text(cliente.clienteActual.email),
                  leading: Icon(Icons.email),
                ),
                ListTile(
                  title: Text(cliente.clienteActual.telefono.toString()),
                  leading: Icon(Icons.phone),
                ),
                ListTile(
                  title: Text(cliente.clienteActual.direccion.calle +
                      ' ' +
                      cliente.clienteActual.direccion.numero.toString()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(cliente.clienteActual.direccion.codigoPostal
                              .toString() +
                          ', ' +
                          cliente.clienteActual.direccion.ciudad +
                          ', ' +
                          cliente.clienteActual.direccion.provincia),
                      cliente.clienteActual.direccion.aclaracion != null
                          ? Text(cliente.clienteActual.direccion.aclaracion)
                          : Container(),
                    ],
                  ),
                  leading: Icon(Icons.location_on),
                ),
              ],
            ),
            _getAutenticado(cliente)
          ],
        ));
  }

  _getAutenticado(ClienteNotifier cliente) {
    bool auth = cliente.clienteActual.estaAutenticado;
    return ListTile(
        title: Text(auth == true ? 'Usuario Autenticado' : 'Usuario No Autenticado'),
        leading:  Icon(
            Icons.verified_user,
          ),
        trailing: auth == false ? FlatButton(color: Colors.yellow, onPressed: () => cliente.setAutenticado(), child: Text('Autenticar'),) : SizedBox(),
        );
  }
}
