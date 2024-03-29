import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kosherparatodos/src/Widget/export.dart';
import 'package:kosherparatodos/src/Widget/title_detail_page.dart';
import 'package:kosherparatodos/src/pages/user_pages/widgets/export.dart';
import 'package:kosherparatodos/src/pages/user_pages/widgets/historial_detail_info_card.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/utils/show_messages.dart';
import 'bloc/bloc.dart';

class HistorialDetail extends StatelessWidget {
  HistorialDetail({Key key, this.pedidoID, this.pedidoSelected})
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
                iconTheme: IconThemeData(color: Colors.black),
                elevation: 0,
                backgroundColor: Colors.white,
              ),
              body: Container(
                margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height / 8),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                color: Colors.white,
                child: !snapshot.hasData
                    ? Center(
                        child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Theme.of(context).accentColor),
                      ))
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TitleDetailPage(
                            title:
                                'Pedido del ${DateFormat('dd/MM').format(pedidoSelected.fecha.toDate())}',
                          ),
                          HistorialDetailInfoCard(
                            pedido: pedidoSelected,
                          ),
                          Expanded(
                            flex: 3,
                            child: ListView.builder(
                              itemCount: pedidoSelected.productos.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  PedidoDetailItem(
                                detalle: pedidoSelected.productos[index],
                              ),
                            ),
                          ),
                          BottomPedidoTotal(total: pedidoSelected.total),
                        ],
                      ),
              ),
              floatingActionButton: !snapshot.hasData
                  ? Container()
                  : _getTimeDiff(pedidoSelected.fecha) ||
                          pedidoSelected.pagado ||
                          pedidoSelected.estadoEntrega !=
                              EnumEntrega.EnPreparacion
                      ? SizedBox()
                      : _btnDelete(
                          context,
                          Pedido.enumEntregaToString(
                              pedidoSelected.estadoEntrega)),
            );
          }
        });
  }

  Widget _btnDelete(BuildContext context, String estado) {
    return FloatingActionButton.extended(
      onPressed: () => _eliminarPedido(context),
      backgroundColor: Theme.of(context).primaryColor,
      label: Text(
        'Eliminar',
        style: TextStyle(color: Colors.white),
      ),
      icon: Icon(Icons.clear, size: 36.0, color: Colors.white),
    );
  }

//Si el pedido tiene mas de 24 horas ya no se puede eliminar
  bool _getTimeDiff(Timestamp time) {
    if (time.toDate().difference(Timestamp.now().toDate()).inHours < -24) {
      return true; //Tiene mas de 24 hs
    }
    return false;
  }

  void _eliminarPedido(BuildContext context) {
    blocUserData.eliminarPedido(pedidoSelected).then((value) {
      Show('Eliminando pedido...');
      Show('Pedido eliminado.');
      Navigator.of(context).pop();
      blocUserData.updatePedidoFromBloc(pedidoSelected.pedidoID);
    }, onError: (onError) => Show('No se pudo eliminar.'));
  }
}
