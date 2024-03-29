import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kosherparatodos/src/Widget/export.dart';
import 'package:kosherparatodos/src/pages/admin_pages/widgets/pedido_card_widget.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/pages/user_pages/historial_pedidos/export.dart';
import 'bloc/bloc.dart';

class HistorialList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Pedido>>(
        stream: blocUserData.getListPedidos,
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(
                child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor),
            ));
          else
            return snapshot.data.isEmpty
                ? EmptyData(
                    text: 'No hay pedidos',
                  )
                : ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PedidoCardWidget(
                        envio: snapshot.data[index].envio,
                        estado: Pedido.enumEntregaToString(
                            snapshot.data[index].estadoEntrega),
                        action: () => _goToDetails(
                            context, snapshot.data[index].pedidoID),
                        pagado: snapshot.data[index].pagado,
                        title:
                            'Pedido del ${DateFormat('dd/MM').format(snapshot.data[index].fecha.toDate())}',
                        subtitle:
                            'Total: \$${snapshot.data[index].total.truncate()}',
                      );
                    },
                  );
        });
  }

  void _goToDetails(BuildContext context, String pedidoID) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HistorialDetail(
                  pedidoID: pedidoID,
                )));
  }
}
