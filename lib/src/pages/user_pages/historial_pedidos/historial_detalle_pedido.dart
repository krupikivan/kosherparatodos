import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/pedido.dart';
import 'package:kosherparatodos/src/utils/converter.dart';
import 'package:kosherparatodos/src/utils/show_messages.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;
import 'bloc/bloc.dart';

class HistorialDetallePedido extends StatelessWidget {
  HistorialDetallePedido({Key key, this.pedidoID, this.pedidoSelected})
      : super(key: key);
  final String pedidoID;
  Pedido pedidoSelected;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Pedido>>(
        stream: blocUserData.getListPedidos,
        builder: (context, snapshot) {
          // Si el pedido fue eliminado preguntamos al listado si lo tiene o no
          if (!snapshot.hasData ||
              !snapshot.data.any((element) => element.pedidoID == pedidoID)) {
            return Center(child: CircularProgressIndicator());
          } else {
            // Si el elemento no esta en la lista volvemos porque se elimino el pedido
            pedidoSelected = snapshot.data
                .firstWhere((element) => element.pedidoID == pedidoID);
            return Scaffold(
              appBar: AppBar(
                backgroundColor: MyTheme.Colors.accent,
                title: Text("Detalle de pedido"),
              ),
              body: Container(
                child: !snapshot.hasData
                    ? Center(
                        child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            MyTheme.Colors.accent),
                      ))
                    : ListView.builder(
                        itemCount: pedidoSelected.productos.length,
                        itemBuilder: (BuildContext context, int index) =>
                            ListTile(
                          title:
                              Text(pedidoSelected.productos[index].descripcion),
                          subtitle: Text(
                              '\$${pedidoSelected.productos[index].precio}'),
                        ),
                      ),
              ),
              floatingActionButton: !snapshot.hasData
                  ? Container()
                  : _bntExpanded(
                      context,
                      Convert.enumEntregaToString(
                          pedidoSelected.estadoEntrega)),
            );
          }
        });
  }

  Widget _bntExpanded(BuildContext context, String estado) {
    return SpeedDial(
      marginRight: 10,
      visible: estado != 'Entregado' ? true : false,
      overlayOpacity: 0.3,
      overlayColor: MyTheme.Colors.white,
      heroTag: 'bntExpand',
      backgroundColor: MyTheme.Colors.accent,
      children: [
        SpeedDialChild(
          child: Icon(Icons.edit, size: 36.0, color: MyTheme.Colors.white),
          backgroundColor: MyTheme.Colors.accent,
          label: "Editar",
          onTap: () => _editarPedido(context),
        ),
        SpeedDialChild(
          child: Icon(Icons.clear, size: 36.0, color: MyTheme.Colors.white),
          backgroundColor: MyTheme.Colors.accent,
          label: "Eliminar",
          onTap: () => _eliminarPedido(context),
        )
      ],
      child: Icon(Icons.add, color: MyTheme.Colors.white),
    );
  }

  void _editarPedido(BuildContext context) {
    blocUserData.editarPedido(pedidoSelected);
    Navigator.pop(context);
    Navigator.of(context).push(new MaterialPageRoute(
        builder: (BuildContext context) => new DetallePedidoListPage()));
  }

  void _eliminarPedido(BuildContext context) {
    blocUserData.eliminarPedido(pedidoSelected).then((value) {
      Show('Eliminando pedido...');
      Show('Pedido eliminado.');
      Navigator.of(context).pop();
      blocUserData.updatePedidoFromBloc(pedidoSelected.pedidoID);
    }, onError: (onError) => Show('No se pudo eliminar.'));
    // .whenComplete(() {});
  }
}
