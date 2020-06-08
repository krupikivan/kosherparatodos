import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:kosherparatodos/src/Widget/show_toast.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/pedido.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;
import 'bloc/bloc.dart';

class HistorialDetallePedido extends StatelessWidget {
  HistorialDetallePedido({Key key, this.pedidoID}) : super(key: key);
  final String pedidoID;
  Pedido pedidoSelected;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Pedido>>(
        stream: blocUserData.getListPedidos,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return CircularProgressIndicator();
          else
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
                        subtitle: Text('\$${pedidoSelected.productos[index].precio}'),
                      ),
                    ),
            ),
            floatingActionButton: !snapshot.hasData
                ? Container()
                : _bntExpanded(context, pedidoSelected.estado),
          );
        });
  }

  Widget _bntExpanded(context, String estado) {
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

  _eliminarPedido(context) {
    blocUserData.eliminarPedido(pedidoSelected);
    Navigator.pop(context);
    ShowToast().show('Pedido eliminado', 5);
  }
}
