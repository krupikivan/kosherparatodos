import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/admin_widgets/user_data_widget.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
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
                iconTheme: IconThemeData(color: MyTheme.Colors.black),
                elevation: 0,
                backgroundColor: MyTheme.Colors.white,
              ),
              body: Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 8),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                color: MyTheme.Colors.white,
                child: !snapshot.hasData
                    ? Center(
                        child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            MyTheme.Colors.accent),
                      ))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Detalle del pedido',
                            style: TextStyle(
                                color: MyTheme.Colors.primary, fontSize: 30),
                          ),
                          Expanded(
                            flex: 3,
                            child: ListView.builder(
                              itemCount: pedidoSelected.productos.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  ListTile(
                                title: Text(
                                    '${pedidoSelected.productos[index].cantidad}x  ${pedidoSelected.productos[index].descripcion}'),
                                subtitle: Text(
                                    '\$${pedidoSelected.productos[index].precio}'),
                              ),
                            ),
                          ),
                          Container(
                            decoration:
                                BoxDecoration(color: MyTheme.Colors.primary),
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
                                  text: '\$${pedidoSelected.total.truncate()}',
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                        ],
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
    return FloatingActionButton.extended(
      onPressed: () => _eliminarPedido(context),
      backgroundColor: MyTheme.Colors.primary,
      label: Text('Eliminar'),
      icon: Icon(Icons.clear, size: 36.0, color: MyTheme.Colors.white),
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
