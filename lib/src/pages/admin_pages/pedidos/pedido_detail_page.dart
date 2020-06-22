import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/export.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/pedido_notifier.dart';
import 'package:kosherparatodos/src/utils/converter.dart';
import 'package:provider/provider.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class PedidoDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PedidoNotifier pedido = Provider.of<PedidoNotifier>(context);
    return Scaffold(
      appBar: AppBar(
        actionsIconTheme: IconThemeData(color: MyTheme.Colors.black),
        iconTheme: IconThemeData(color: MyTheme.Colors.black),
      ),
      body: Container(
        color: Colors.grey.shade50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TitleDetailPage(
              title:
                  'Cliente: ${pedido.pedidoActual.cliente.nombre.nombre} ${pedido.pedidoActual.cliente.nombre.apellido}',
              subtitle:
                  'Fecha: ${convert.getFechaFromTimestamp(pedido.pedidoActual.fecha)}',
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
                    _getEstadoPago(pedido),
                    _getEstadoEntregado(pedido),
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

  Widget _getEstadoPago(PedidoNotifier pedido) {
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
                selectedColor: MyTheme.lighten(MyTheme.Colors.warning, 0.6),
                label: Text('No Pagado'),
                labelStyle: TextStyle(
                  color: pedido.pedidoActual.pagado != true
                      ? MyTheme.darken(MyTheme.Colors.warning, 0.3)
                      : MyTheme.Colors.black,
                ),
                onSelected: (nopagado) => !nopagado ? null : _setPagado(pedido),
              ),
              SizedBox(
                width: 10,
              ),
              ChoiceChip(
                selected: pedido.pedidoActual.pagado,
                selectedColor: MyTheme.lighten(MyTheme.Colors.green, 0.5),
                label: Text('Pagado'),
                labelStyle: TextStyle(
                  color: pedido.pedidoActual.pagado == true
                      ? MyTheme.darken(MyTheme.Colors.green, 0.3)
                      : MyTheme.Colors.black,
                ),
                onSelected: (pagado) => !pagado ? null : _setPagado(pedido),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getEstadoEntregado(PedidoNotifier pedido) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Seleccione el estado de entrega:"),
        Container(
          height: 40,
          padding: EdgeInsets.all(5),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            // pedido.getEstadoEntrega
            //     .map((value) =>
            //         DropdownMenuItem(child: Text(value), value: value))
            //     .toList(),
            // onChanged: (value) {
            // pedido.setEstadoEntrega(value);
            // },
            // isExpanded: false,
            //Mostramos el valor del estado del pedido comparandolo con el vector cargado en firebase
            // value: pedido.getEstadoEntrega
            // .firstWhere((element) => element == pedido.pedidoActual.estadoEntrega),
            itemCount: pedido.getEstadoEntrega.length,
            itemBuilder: (BuildContext context, int index) {
              return Row(
                children: <Widget>[
                  ChoiceChip(
                    selected: pedido.pedidoActual.estadoEntrega.index == index,
                    selectedColor: MyTheme.Colors.primary,
                    label: Text(Convert.enumEntregaToString(
                        pedido.getEstadoEntrega[index])),
                    labelStyle: TextStyle(
                      color: pedido.pedidoActual.estadoEntrega.index == index
                          ? MyTheme.Colors.white
                          : MyTheme.Colors.black,
                    ),
                    onSelected: (estado) => !estado
                        ? null
                        : pedido
                            .setEstadoEntrega(pedido.getEstadoEntrega[index]),
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
