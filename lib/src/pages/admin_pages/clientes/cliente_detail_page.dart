import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/export.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/cliente_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/pedido_notifier.dart';
import 'package:provider/provider.dart';

class ClienteDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ClienteNotifier cliente = Provider.of<ClienteNotifier>(context);
    // PedidoNotifier pedido = Provider.of<PedidoNotifier>(context);
    cliente.getPedidosCliente(Provider.of<PedidoNotifier>(context));
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomDataList(
                  multiLines: false,
                  campo: 'Nombre',
                  dato1:
                      '${cliente.clienteActual.nombre.nombre} ${cliente.clienteActual.nombre.apellido}'),
              CustomDataList(
                  multiLines: false,
                  campo: 'Email',
                  dato1: cliente.clienteActual.email),
              CustomDataList(
                  multiLines: false,
                  campo: 'Telefono',
                  dato1: cliente.clienteActual.telefono.toString()),
              CustomDataList(
                  multiLines: true,
                  campo: 'Direccion',
                  dato1:
                      '${cliente.clienteActual.direccion.calle} ${cliente.clienteActual.direccion.numero} ${cliente.clienteActual.direccion.piso} ${cliente.clienteActual.direccion.depto}',
                  dato2:
                      '${cliente.clienteActual.direccion.codigoPostal}, ${cliente.clienteActual.direccion.ciudad}, ${cliente.clienteActual.direccion.provincia}, ${cliente.clienteActual.direccion.aclaracion}'),
              _getAutenticado(cliente, context),
            ],
          ),
        ));
  }

  Widget _getAutenticado(ClienteNotifier cliente, context) {
    final bool auth = cliente.clienteActual.estaAutenticado;
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            auth == true ? 'Usuario Habilitado' : 'Usuario No Habilitado',
            style: TextStyle(
                color: auth != true
                    ? Theme.of(context).accentColor
                    : Theme.of(context).primaryColorLight,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 20),
          auth != true
              ? ActionChip(
                  backgroundColor: auth != true
                      ? Theme.of(context).accentColor
                      : Theme.of(context).primaryColorLight,
                  label: Text(
                    'Habilitar',
                    style: TextStyle(
                        color: auth == true ? Colors.white : Colors.black),
                  ),
                  onPressed: () => cliente.setAutenticado(),
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
