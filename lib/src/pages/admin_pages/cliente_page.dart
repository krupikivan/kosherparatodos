import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/pages/admin_pages/cliente_detail_page.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/cliente_notifier.dart';
import 'package:provider/provider.dart';

class ClientePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ClienteNotifier>(
      builder: (context, cliente, _) => RefreshIndicator(
        child: ListView.separated(
          itemBuilder: (BuildContext context, int index) => ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(cliente.clienteList[index].name),
            subtitle: Text(cliente.clienteList[index].email),
            onTap: () {
              cliente.clienteActual = cliente.clienteList[index];
              _goToDetails(context);
            },
          ),
          itemCount: cliente.clienteList.length,
          separatorBuilder: (BuildContext context, int index) => Divider(
            color: Colors.grey,
          ),
        ),
        onRefresh: () => _refreshList(cliente),
      ),
    );
  }

  _goToDetails(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ClienteDetailPage()));
  }

  Future<void> _refreshList(cliente) async {
    cliente.getClientes(cliente);
  }
}
