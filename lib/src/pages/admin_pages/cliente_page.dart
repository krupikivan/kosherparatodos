import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/models/cliente.dart';
import 'package:kosherparatodos/src/pages/admin_pages/cliente_detail_page.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/admin_provider.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/cliente_notifier.dart';
import 'package:provider/provider.dart';

class ClientePage extends StatelessWidget {
//   const ClientePage({Key key}) : super(key: key);

//   @override
//   _ClientePageState createState() => _ClientePageState();
// }

// class _ClientePageState extends State<ClientePage> {
//   @override
//   void initState() {
//     ClienteNotifier cliente = Provider.of<ClienteNotifier>(context, listen: false);
//     adminProvider.getClientes(cliente);
//     super.initState();
//   }

  @override
  Widget build(BuildContext context) {
    // ClienteNotifier cliente = Provider.of<ClienteNotifier>(context);
    return Scaffold(
      body: Consumer<ClienteNotifier>(
        builder: (context, cliente, _) => RefreshIndicator(
                  child: ListView.separated(
            itemBuilder: (BuildContext context, int index) => ListTile(
              leading: Icon(Icons.account_circle),
              title: Text(cliente.clienteList[index].name),
              subtitle: Text(cliente.clienteList[index].email),
              onTap: () {
                cliente.clienteActual = cliente.clienteList[index];
                _goToDetails(context);
                // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ClienteDetailPage(context: context,)));
              },
            ),
            itemCount: cliente.clienteList.length,
            separatorBuilder: (BuildContext context, int index) => Divider(
              color: Colors.grey,
            ),
          ), onRefresh: () => _refreshList(cliente),
        ),
      ),
    );
  }

    _goToDetails(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ClienteDetailPage(
                )));
  }

    Future<void> _refreshList(cliente) async {
      // adminProvider.getClientes(Provider.of<ClienteNotifier>(context, listen: false));
      adminProvider.getClientes(cliente);
    }

}
