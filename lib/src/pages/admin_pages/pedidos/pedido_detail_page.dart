import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              'Cliente: ${pedido.pedidoActual.cliente.nombre.nombre} ${pedido.pedidoActual.cliente.nombre.apellido}',
              style: TextStyle(
                  color: MyTheme.Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 20),
            ),
            Text(
              'Fecha: ${convert.getFechaFromTimestamp(pedido.pedidoActual.fecha)}',
              style: TextStyle(
                  fontSize: 15,
                  color: MyTheme.Colors.black,
                  fontWeight: FontWeight.w100),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey.shade50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 7,
              child: pedido.pedidoActual.productos == null
                  ? Center(child: Text('No hay pedidos'))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: pedido.pedidoActual.productos.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            ListTile(
                              leading: Container(
                                width: 30,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          '${pedido.pedidoActual.productos[index].cantidad}',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                        Text(
                                          'x',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              title: Text(
                                  '${pedido.pedidoActual.productos[index].descripcion}'),
                              trailing: Text(

                                  ///TODO: ESTE PRECIO DEBERIA SER EL TOTAL POR PRODUCTO
                                  '\$${pedido.pedidoActual.productos[index].precio}'),
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
              child: ListView(
                children: <Widget>[
                  _getEstadoPago(pedido),
                  _getEstadoEntregado(pedido),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: _price(pedido),
            ),
          ],
        ),
      ),
    );
  }

  Widget _price(PedidoNotifier pedido) {
    return Container(
      decoration: BoxDecoration(color: MyTheme.Colors.primary),
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TitleText(
            text: 'Total',
            color: MyTheme.Colors.white,
            fontWeight: FontWeight.w500,
          ),
          TitleText(
            color: MyTheme.Colors.white,
            text: '\$${pedido.pedidoActual.total}',
            fontWeight: FontWeight.w500,
          ),
        ],
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

            itemBuilder: (BuildContext context, int index) {
              return ChoiceChip(
                selected: pedido.pedidoActual.estadoEntrega.index == index,
                selectedColor: MyTheme.lighten(MyTheme.Colors.green, 0.5),
                label: Text(Convert.enumEntregaToString(
                    pedido.pedidoActual.estadoEntrega)),
                labelStyle: TextStyle(
                  color: pedido.pedidoActual.pagado == true
                      ? MyTheme.darken(MyTheme.Colors.green, 0.3)
                      : MyTheme.Colors.black,
                ),
                onSelected: (pagado) => !pagado ? null : _setPagado(pedido),
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
