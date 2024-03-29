import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kosherparatodos/src/Widget/export.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/pages/admin_pages/pedidos/pedido_detail_page.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/pedido_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/widgets/export.dart';
import 'package:provider/provider.dart';

class PedidosListPage extends StatelessWidget {
  const PedidosListPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Positioned(
          child: Consumer<PedidoNotifier>(
            builder: (context, pedido, _) => pedido.filterList.isNotEmpty
                ? _showList(pedido.filterList, pedido)
                : _showList(pedido.pedidoList, pedido),
          ),
        ),
        Positioned(
            bottom: size.height * 0.04,
            right: size.width * 0.3,
            left: size.width * 0.3,
            child: FloatingActionButton(
              onPressed: () => _filterList(context),
              backgroundColor: Theme.of(context).primaryColor,
              child: Icon(Icons.filter_list),
            ))
      ],
    );
  }

  Widget _showList(List<Pedido> list, PedidoNotifier not) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) => PedidoCardWidget(
        estado: Pedido.enumEntregaToString(list[index].estadoEntrega),
        action: () {
          not.pedidoActual = list[index];
          _goToDetails(context);
        },
        envio: list[index].envio,
        pagado: list[index].pagado,
        title:
            '${list[index].cliente.nombre.nombre} ${list[index].cliente.nombre.apellido}',
        subtitle:
            'Fecha: ${DateFormat('dd/MM').format(list[index].fecha.toDate())} - Total: \$${list[index].total.truncate()}',
      ),
      itemCount: list.length,
    );
  }

  _filterList(context1) {
    final TextStyle style =
        TextStyle(color: Theme.of(context1).primaryColor, fontSize: 16);
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
                child: Text("Todos", style: style),
                onPressed: () {
                  if (Provider.of<PedidoNotifier>(context1, listen: false)
                      .filtrar()) {}
                  Navigator.of(context).pop();
                }),
            FlatButton(
                child: Text("Entregados", style: style),
                onPressed: () {
                  if (Provider.of<PedidoNotifier>(context1, listen: false)
                      .filtrar(char: 'E')) {
                    ShowToast().show('No se encontraron', 5);
                  }
                  Navigator.of(context).pop();
                }),
            FlatButton(
                child: Text("En Preparacion", style: style),
                onPressed: () {
                  if (Provider.of<PedidoNotifier>(context1, listen: false)
                      .filtrar(char: 'EP')) {
                    ShowToast().show('No se encontraron', 5);
                  }
                  Navigator.of(context).pop();
                }),
            FlatButton(
              onPressed: () {
                if (Provider.of<PedidoNotifier>(context1, listen: false)
                    .filtrar(char: 'C')) {
                  ShowToast().show('No se encontraron', 5);
                }
                Navigator.of(context).pop();
              },
              child: Text("Cancelado", style: style),
            ),
            FlatButton(
              onPressed: () {
                if (Provider.of<PedidoNotifier>(context1, listen: false)
                    .filtrar(char: 'P')) {
                  ShowToast().show('No se encontraron', 5);
                }
                Navigator.of(context).pop();
              },
              child: Text("Pagado", style: style),
            ),
            FlatButton(
              onPressed: () {
                if (Provider.of<PedidoNotifier>(context1, listen: false)
                    .filtrar(char: 'NP')) {
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
