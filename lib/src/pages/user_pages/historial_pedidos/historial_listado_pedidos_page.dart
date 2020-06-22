import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kosherparatodos/src/Widget/admin_widgets/admin_widget_export.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/pages/user_pages/historial_pedidos/historial.dart';
import 'package:kosherparatodos/src/utils/converter.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;
import 'bloc/bloc.dart';

class HistorialListadoPedidoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Pedido>>(
        stream: blocUserData.getListPedidos,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
                child: CircularProgressIndicator(
              valueColor:
                  new AlwaysStoppedAnimation<Color>(MyTheme.Colors.primary),
            ));
          else
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return PedidoCardWidget(
                  estado: Convert.enumEntregaToString(
                      snapshot.data[index].estadoEntrega),
                  action: () =>
                      _goToDetails(context, snapshot.data[index].pedidoID),
                  pagado: snapshot.data[index].pagado,
                  title:
                      '${snapshot.data[index].cliente.nombre.nombre} ${snapshot.data[index].cliente.nombre.apellido}',
                  subtitle: 'Total: \$${snapshot.data[index].total.truncate()}',
                );
              },
            );
        });
  }

  void _goToDetails(BuildContext context, String pedidoID) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HistorialDetallePedido(
                  pedidoID: pedidoID,
                )));
  }
}
