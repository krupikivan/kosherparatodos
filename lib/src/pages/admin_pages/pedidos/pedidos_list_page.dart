import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/export.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/pages/admin_pages/pedidos/pedido_detail_page.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/pedido_notifier.dart';
import 'package:kosherparatodos/src/utils/converter.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;
import 'package:provider/provider.dart';

class PedidosListPage extends StatelessWidget {
  const PedidosListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Consumer<PedidoNotifier>(
            builder: (context, pedido, _) => pedido.filterList.isNotEmpty
                ? _showList(pedido.filterList, pedido)
                : _showList(pedido.pedidoList, pedido),
          ),
        ),
        Expanded(
            child: FloatingActionButton(
          onPressed: () => _filterList(context),
          backgroundColor: MyTheme.Colors.primary,
          child: Icon(Icons.filter_list),
        ))
      ],
    );
  }

  Widget _showList(List<Pedido> list, PedidoNotifier not) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => PedidoCardWidget(
        estado: Convert.enumEntregaToString(list[index].estadoEntrega),
        action: () {
          not.pedidoActual = list[index];
          _goToDetails(context);
        },
        pagado: list[index].pagado,
        title:
            '${list[index].cliente.nombre.nombre} ${list[index].cliente.nombre.apellido}',
        subtitle: 'Total: \$${list[index].total.truncate()}',
      ),
      itemCount: list.length,
    );
  }

  _filterList(context1) {
    final TextStyle style =
        TextStyle(color: MyTheme.Colors.primary, fontSize: 16);
    return showDialog(
      context: context1,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Text("Filtrar pedidos"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FlatButton(
                child: Text("Entregados", style: style),
                onPressed: () {
                  if (Provider.of<PedidoNotifier>(context1, listen: false)
                      .filtrar('E')) {
                    ShowToast().show('No se encontraron', 5);
                  }
                  Navigator.of(context).pop();
                }),
            FlatButton(
                child: Text("En Preparacion", style: style),
                onPressed: () {
                  if (Provider.of<PedidoNotifier>(context1, listen: false)
                      .filtrar('EP')) {
                    ShowToast().show('No se encontraron', 5);
                  }
                  Navigator.of(context).pop();
                }),
            FlatButton(
              onPressed: () {
                if (Provider.of<PedidoNotifier>(context1, listen: false)
                    .filtrar('C')) {
                  ShowToast().show('No se encontraron', 5);
                }
                Navigator.of(context).pop();
              },
              child: Text("Cancelado", style: style),
            ),
            FlatButton(
              onPressed: () {
                if (Provider.of<PedidoNotifier>(context1, listen: false)
                    .filtrar('P')) {
                  ShowToast().show('No se encontraron', 5);
                }
                Navigator.of(context).pop();
              },
              child: Text("Pagado", style: style),
            ),
            FlatButton(
              onPressed: () {
                if (Provider.of<PedidoNotifier>(context1, listen: false)
                    .filtrar('NP')) {
                  ShowToast().show('No se encontraron', 5);
                }
                Navigator.of(context).pop();
              },
              child: Text("No Pagado", style: style),
            ),
          ],
        ),
      ),
    );
  }

  void _goToDetails(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => PedidoDetailPage()));
  }
}
