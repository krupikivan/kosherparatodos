import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/admin_widgets/admin_widget_export.dart';
import 'package:kosherparatodos/src/pages/admin_pages/pedidos/pedido_detail_page.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/pedido_notifier.dart';
import 'package:provider/provider.dart';

class PedidosPage extends StatelessWidget {
  const PedidosPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PedidoNotifier>(
      builder: (context, pedido, _) => RefreshIndicator(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) => PedidoCardWidget(
            estado: pedido.pedidoList[index].estado,
            action: () {
              pedido.pedidoActual = pedido.pedidoList[index];
              _goToDetails(context);
            },
            pagado: pedido.pedidoList[index].pagado,
            title:
                '${pedido.pedidoList[index].cliente.nombre.nombre} ${pedido.pedidoList[index].cliente.nombre.apellido}',
            subtitle: 'Total: \$${pedido.pedidoList[index].total.truncate()}',
          ),
          itemCount: pedido.pedidoList.length,
        ),
        onRefresh: () => _refreshList(pedido),
      ),
    );
  }

  void _goToDetails(context) {
    // Provider.of<ProductoNotifier>(context, listen: false).getDetalleProducto();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PedidoDetailPage()));
  }

  Future<void> _refreshList(PedidoNotifier pedido) async {
    pedido.getPedidos();
  }
}
