import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/export.dart';
import 'package:kosherparatodos/src/models/cliente.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/cliente_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/pedido_notifier.dart';
import 'package:provider/provider.dart';

class ClienteDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ClienteNotifier cliente = Provider.of<ClienteNotifier>(context);
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
              cliente.clienteActual.telefono == 0
                  ? SizedBox()
                  : CustomDataList(
                      multiLines: false,
                      campo: 'Telefono',
                      dato1: cliente.clienteActual.telefono.toString()),
              CustomDataList(
                  multiLines: true,
                  campo: 'Direccion',
                  dato1: _getDato1(cliente.clienteActual.direccion),
                  dato2: _getDato2(cliente.clienteActual.direccion)),
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
                        color: auth == true ? Colors.white : Colors.white),
                  ),
                  onPressed: () => cliente.setAutenticado(),
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  String _getDato1(Direccion direccion) {
    String dato1 = '';
    final String calle = direccion.calle != "" ? direccion.calle : null;
    final int numero = direccion.numero != 0 ? direccion.numero : null;
    final String piso = direccion.piso != "" ? direccion.piso : null;
    final String depto = direccion.depto != "" ? direccion.depto : null;
    if (calle != null) {
      dato1 = calle;
    }
    if (numero != null) {
      dato1 = dato1 != '' ? '$dato1, $numero' : numero.toString();
    }
    if (piso != null) {
      dato1 = dato1 != '' ? '$dato1, $piso' : piso;
    }
    if (depto != null) {
      dato1 = dato1 != '' ? '$dato1, $depto' : depto;
    }
    return dato1;
  }

  String _getDato2(Direccion direccion) {
    String dato2 = '';
    final int codigoPostal =
        direccion.codigoPostal != 0 ? direccion.codigoPostal : null;
    final String ciudad = direccion.ciudad != '' ? direccion.ciudad : null;
    final String provincia =
        direccion.provincia != "" ? direccion.provincia : null;
    final String aclaracion =
        direccion.aclaracion != "" ? direccion.aclaracion : null;
    if (codigoPostal != null) {
      dato2 = codigoPostal.toString();
    }
    if (ciudad != null) {
      dato2 = dato2 != '' ? '$dato2, $ciudad' : ciudad;
    }
    if (provincia != null) {
      dato2 = dato2 != '' ? '$dato2, $provincia' : provincia;
    }
    if (aclaracion != null) {
      dato2 = dato2 != '' ? '$dato2, $aclaracion' : aclaracion;
    }
    return dato2;
  }
}
