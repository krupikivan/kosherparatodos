import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:kosherparatodos/src/Widget/show_toast.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/pedido.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

import 'bloc/bloc.dart';

class HistorialDetallePedido extends StatelessWidget {
  const HistorialDetallePedido({Key key, this.uid}) : super(key: key);
  final String uid;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Pedido>(
        stream: blocUserData.getPedidoSelected,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: MyTheme.Colors.dark,
              title: Text("Detalle de pedido"),
            ),
            body: Container(
              child: !snapshot.hasData
                  ? Center(
                      child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          MyTheme.Colors.dark),
                    ))
                  : ListView.builder(
                      itemCount: snapshot.data.productos.length,
                      itemBuilder: (BuildContext context, int index) =>
                          ListTile(
                        title: Text(
                            snapshot.data.productos[index].descripcion),
                        subtitle: Text('\$' +
                            snapshot.data.productos[index].precio
                                .toString()),
                      ),
                    ),
            ),
            floatingActionButton: !snapshot.hasData ? Container() : _bntExpanded(context, snapshot.data.estado),
          );
        });
  }

  Widget _bntExpanded(context, Estado estado) {
        return SpeedDial(
      marginRight: 10,
      visible: estado != Estado.ENTREGADO ? true : false,
      overlayOpacity: 0.3,
      overlayColor: MyTheme.Colors.light,
      heroTag: 'bntExpand',
      backgroundColor: MyTheme.Colors.dark,
      child: Icon(Icons.add, color: MyTheme.Colors.light),
      children: [
        SpeedDialChild(
          child: Icon(Icons.edit, size: 36.0, color: MyTheme.Colors.light),
          backgroundColor: MyTheme.Colors.dark,
          label: "Editar",
          onTap: () => _addToPedido(context),
        ),
        SpeedDialChild(
          child: Icon(Icons.clear, size: 36.0, color: MyTheme.Colors.light),
          backgroundColor: MyTheme.Colors.dark,
          label: "Eliminar",
          onTap: () => _deletePedido(context),
        )
      ],
    );
  }

  _addToPedido(context) {
    blocUserData.addPedidoForEdit();
    Navigator.pop(context);
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new DetallePedidoListPage()));
  }

  _deletePedido(context) {
    blocUserData.deletePedido();
    Navigator.pop(context);
    ShowToast().show('Pedido eliminado', 5);
  }
}
