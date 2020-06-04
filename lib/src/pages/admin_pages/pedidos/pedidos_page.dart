import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kosherparatodos/src/pages/admin_pages/pedidos/pedido_detail_page.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/pedido_notifier.dart';
import 'package:kosherparatodos/src/utils/converter.dart';
import 'package:provider/provider.dart';

class PedidosPage extends StatelessWidget {
  const PedidosPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<PedidoNotifier>(
        builder: (context, pedido, _) => RefreshIndicator(
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) => ListTile(
              // leading: Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     Icon(FontAwesomeIcons.truck, color: pedido.pedidoList[index].estado == 'Entregado' ? Colors.green : pedido.pedidoList[index].estado == 'En Preparacion' ? Colors.orange : Colors.red,),
              //   ],
              // ),
              title: Text(pedido.pedidoList[index].cliente.nombre.nombre + ' ' + pedido.pedidoList[index].cliente.nombre.apellido + " - " + convert.getFechaFromTimestamp(pedido.pedidoList[index].fecha)),
              subtitle: Text('Total: \$' + pedido.pedidoList[index].total.truncate().toString()),
              onTap: () {
                pedido.pedidoActual = pedido.pedidoList[index];
                _goToDetails(context);
              },
              trailing: SizedBox(
                width: 100,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Expanded(child: Icon(FontAwesomeIcons.truck, color: pedido.pedidoList[index].estado == 'Entregado' ? Colors.green : pedido.pedidoList[index].estado == 'En Preparacion' ? Colors.orange : Colors.red,)),
                    Expanded(child: Icon(Icons.payment, color: pedido.pedidoList[index].pagado == true ? Colors.green : Colors.red,)),
                  ],
                ),
              ),
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

  _goToDetails(context) {
    // Provider.of<PedidoNotifier>(context, listen: false).getDetallePedido();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PedidoDetailPage()));
  }

  Future<void> _refreshList(PedidoNotifier pedido) async {
    pedido.getPedidos();
  }

}
