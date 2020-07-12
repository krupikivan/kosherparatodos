import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/export.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/pedido_notifier.dart';
import 'package:kosherparatodos/src/providers/data_provider.dart';
import 'package:kosherparatodos/src/utils/converter.dart';
import 'package:provider/provider.dart';

class PedidoDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PedidoNotifier pedido = Provider.of<PedidoNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: Colors.black),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: TitleDetailPage(
                    title:
                        'Cliente: ${pedido.pedidoActual.cliente.nombre.nombre} ${pedido.pedidoActual.cliente.nombre.apellido}',
                    subtitle:
                        'Fecha: ${convert.getFechaFromTimestamp(pedido.pedidoActual.fecha)}',
                  ),
                ),
                Expanded(
                  child: Card(
                    color: Colors.white,
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.local_shipping,
                            color: pedido.pedidoActual.envio
                                ? Colors.green
                                : Colors.red,
                          ),
                          Text(
                            pedido.pedidoActual.envio ? 'Enviar' : 'No enviar',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: pedido.pedidoActual.envio
                                    ? Colors.green
                                    : Colors.red),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
            Expanded(
              flex: 5,
              child: pedido.pedidoActual.productos == null
                  ? Center(child: Text('No hay pedidos'))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: pedido.pedidoActual.productos.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            PedidoDetailItem(
                              detalle: pedido.pedidoActual.productos[index],
                            ),
                            Divider(
                              height: 5,
                              indent: 15,
                              endIndent: 15,
                            )
                          ],
                        );
                      },
                    ),
            ),
            Expanded(
              flex: 0,
              child: Divider(
                height: 5,
                color: Colors.grey,
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: <Widget>[
                    _getEstadoPago(pedido, context),
                    _getEstadoEntregado(pedido, context),
                  ],
                ),
              ),
            ),
            Expanded(
              child: BottomPedidoTotal(total: pedido.pedidoActual.total),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getEstadoPago(PedidoNotifier pedido, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Seleccione el estado del pedido"),
        Container(
          height: 40,
          padding: EdgeInsets.all(5),
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              ChoiceChip(
                selected: !pedido.pedidoActual.pagado,
                selectedColor: Theme.of(context).primaryColor,
                label: Text('No Pagado'),
                labelStyle: TextStyle(
                  color: pedido.pedidoActual.pagado != true
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                ),
                onSelected: (nopagado) => !nopagado ? null : _setPagado(pedido),
              ),
              SizedBox(
                width: 10,
              ),
              ChoiceChip(
                selected: pedido.pedidoActual.pagado,
                selectedColor: Theme.of(context).primaryColor,
                label: Text('Pagado'),
                labelStyle: TextStyle(
                  color: pedido.pedidoActual.pagado == true
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                ),
                onSelected: (pagado) => !pagado ? null : _setPagado(pedido),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getEstadoEntregado(PedidoNotifier pedido, context) {
    final data = Provider.of<DataProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Seleccione el estado de entrega:"),
        Container(
          height: 40,
          padding: EdgeInsets.all(5),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: data.getEstadoEntrega.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: <Widget>[
                  data == null
                      ? SizedBox()
                      : ChoiceChip(
                          selected:
                              pedido.pedidoActual.estadoEntrega.index == index,
                          selectedColor: Theme.of(context).primaryColor,
                          label: Text(Pedido.enumEntregaToString(
                              data.getEstadoEntrega[index])),
                          labelStyle: TextStyle(
                            color:
                                pedido.pedidoActual.estadoEntrega.index == index
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                          ),
                          onSelected: (estado) => !estado
                              ? null
                              : pedido.setEstadoEntrega(
                                  data.getEstadoEntrega[index]),
                        ),
                  SizedBox(
                    width: 10,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  void _setPagado(PedidoNotifier pedido) {
    pedido.setPagado();
  }
}
