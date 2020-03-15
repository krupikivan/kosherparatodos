import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/add_remove_button_widget.dart';
import 'package:kosherparatodos/src/models/detalle_pedido.dart';
import 'package:kosherparatodos/src/models/product.dart';
import 'package:kosherparatodos/src/pages/home_pages/bloc/new_pedido_bloc.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class NewDetallePedido extends StatefulWidget {
  NewDetallePedido({Key key, this.producto}) : super(key: key);
  final Producto producto;

  @override
  _NewDetallePedidoState createState() => _NewDetallePedidoState();
}

class _NewDetallePedidoState extends State<NewDetallePedido> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.Colors.dark,
        title: Text(widget.producto.nombre),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Text(
              widget.producto.descripcion,
              style: TextStyle(fontSize: 20),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: widget.producto.opcionCantidad.length,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(widget.producto.tipo +
                          ' ' +
                          widget.producto.opcionCantidad[index].toString() +
                          ' ' +
                          widget.producto.unidadMedida),
                      Row(
                        children: <Widget>[
                          AddRemoveButton(
                            icon: Icons.add,
                            index: index,
                            producto: widget.producto,
                            action: 'add',
                          ),
                          AddRemoveButton(
                            icon: Icons.remove,
                            index: index,
                            producto: widget.producto,
                            action: 'remove',
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
            ),
            Container(
              child: StreamBuilder<List<DetallePedido>>(
                  stream: blocNewPedido.getDetalle,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData || snapshot.data.length == 0)
                      return Container();
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(snapshot.data[index].tipo +
                              ' ' +
                              snapshot.data[index].cantidad.toString() +
                              ' ' +
                              snapshot.data[index].unidadMedida),
                          subtitle: Text(
                              snapshot.data[index].unidades.toString() +
                                  ' ' +
                                  snapshot.data[index].bulto),
                        );
                      },
                    );
                  }),
            ),
            FlatButton(
                onPressed: () {
                  blocNewPedido.onNewDetalle(widget.producto);
                  Navigator.pop(context);
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: MyTheme.Colors.dark,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Agregar al pedido',
                    style: TextStyle(color: MyTheme.Colors.light),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
