import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/add_remove_button_widget.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
import 'package:kosherparatodos/src/models/detalle_pedido.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

import 'bloc/bloc.dart';

class ProductoItemDetalle extends StatelessWidget {
  final Producto producto;

  const ProductoItemDetalle({Key key, this.producto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    blocProductosFirebase.getProductoConcretoFirebase(producto.idProducto);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.Colors.dark,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 20),
              child: TitleText(
                text: producto.nombre,
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: TitleText(
                text: producto.descripcion,
                fontSize: 17,
              ),
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TitleText(
                text:
                    'Seleccione cantidad, a medida que va modificando, se van agregando en el carrito de compra.',
                fontSize: 13,
              ),
            ),
          ),
          SizedBox(height: 15),
          Expanded(
            flex: 5,
            child: StreamBuilder<List<Producto>>(
              stream: blocProductosFirebase.getProductosVigentes,
              builder: (context, snapshot) => !snapshot.hasData
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            MyTheme.Colors.dark),
                      ),
                    )
                  : ListView.builder(
                      itemCount: producto.concreto.length,
                      itemBuilder: (BuildContext context, int index) => Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: ExpansionTile(
                          title: Text(producto.concreto[index].descripcion),
                          subtitle: _getCantidad(index),
                          trailing: _getButtons(index),
                        ),
                      ),
                    ),
            ),
          ),
          Container(
            decoration: BoxDecoration(color: MyTheme.Colors.dark),
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                StreamBuilder<Pedido>(
                    stream: blocPedidoVigente.getPedido,
                    builder: (context, snapshot) {
                      double total = 0;
                      if (snapshot.hasData && snapshot.data.detallePedido != null) {
                        snapshot.data.detallePedido.forEach(
                            (element) {
                              total += element.precioDetalle != null ? element.precioDetalle : 0;
                            }); 
                        }
                        return TitleText(
                                text: 'Total del pedido: ${total.toString()}',
                                color: MyTheme.Colors.minLight,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              );
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCantidad(index) {
    return StreamBuilder<Pedido>(
        stream: blocPedidoVigente.getPedido,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.detallePedido ==  null)
            return Text('');
          else if (snapshot.data.detallePedido.any((value) =>
              value.concreto.idConcreto == producto.concreto[index].idConcreto))
            return Text('Cantidad: ' +
                snapshot.data
                .detallePedido
                    .firstWhere((value) =>
                        value.concreto.idConcreto ==
                        producto.concreto[index].idConcreto)
                    .cantidad
                    .toString());
          else
            return Text('');
        });
  }

  Widget _getButtons(index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        AddRemoveButton(
          icon: Icons.add,
          index: index,
          producto: producto,
          action: 'add',
        ),
        AddRemoveButton(
          icon: Icons.remove,
          index: index,
          producto: producto,
          action: 'remove',
        ),
      ],
    );
  }
}
