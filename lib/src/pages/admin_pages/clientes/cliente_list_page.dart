import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/pages/admin_pages/clientes/cliente_detail_page.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/cliente_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/widgets/export.dart';
import 'package:provider/provider.dart';

class ClienteListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Consumer<ClienteNotifier>(
        builder: (context, cliente, _) => RefreshIndicator(
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) => ClienteCardWidget(
                name:
                    '${cliente.clienteList[index].nombre.nombre} ${cliente.clienteList[index].nombre.apellido}',
                estado: cliente.clienteList[index].estaAutenticado,
                action: () {
                  cliente.clienteActual = cliente.clienteList[index];
                  _detalleCliente(context, cliente);
                }),
            itemCount: cliente.clienteList.length,
            separatorBuilder: (BuildContext context, int index) => Divider(
              color: Theme.of(context).dividerColor,
            ),
          ),
          onRefresh: () => _refreshList(cliente),
        ),
      ),
    );
  }

  void _detalleCliente(BuildContext context, ClienteNotifier cliente) {
    cliente.pedidoListClear();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ClienteDetailPage()));
  }

  Future<void> _refreshList(ClienteNotifier cliente) async {
    cliente.getClientes();
  }
}
