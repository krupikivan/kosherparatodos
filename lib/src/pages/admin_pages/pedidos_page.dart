import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/pedido_notifier.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;
import 'package:provider/provider.dart';

class PedidosPage extends StatelessWidget {
  const PedidosPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.Colors.dark,
        title: Text(
          "Pedidos",
          style: TextStyle(color: MyTheme.Colors.light),
        ),
      ),
      body: Consumer<PedidoNotifier>(
        builder: (context, pedido, _) => RefreshIndicator(
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) => ListTile(
              leading: Icon(Icons.list),
              // title: Text(_getFecha(pedido.pedidoList[index].fecha.millisecondsSinceEpoch)),
              title: Text(pedido.pedidoList[index].cliente.name.toString()),
              subtitle: Text('\$' + pedido.pedidoList[index].total.truncate().toString()),
              onTap: () {
                pedido.pedidoActual = pedido.pedidoList[index];
                _goToDetails(context);
              },
            ),
            itemCount: pedido.pedidoList.length,
            separatorBuilder: (BuildContext context, int index) => Divider(
              color: Colors.grey,
            ),
          ),
          onRefresh: () => _refreshList(pedido),
        ),
      ),
    );
  }

  _getFecha(int fecha){
    DateTime date = new DateTime.fromMillisecondsSinceEpoch(fecha);
    return DateFormat("HH:mm - dd/MM/yyyy").format(date);
  }

  _goToDetails(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => null));
  }

  Future<void> _refreshList(pedido) async {
    pedido.getPedidos(pedido);
  }

}
