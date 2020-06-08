import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/pages/user_pages/historial_pedidos/historial.dart';
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
                return Card(
                  elevation: 2,
                  child: ListTile(
                    leading: snapshot.data[index].pagado == true
                        ? FaIcon(
                            FontAwesomeIcons.moneyBillAlt,
                            size: 35,
                            color: MyTheme.Colors.green,
                          )
                        : FaIcon(
                            FontAwesomeIcons.moneyBillAlt,
                            size: 35,
                            color: MyTheme.Colors.yellowWarning,
                          ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(DateFormat("dd/MM/yyyy")
                            .format(snapshot.data[index].fecha.toDate())),
                        Text('Total: \$${snapshot.data[index].total}'),
                      ],
                    ),
                    subtitle: Text(snapshot.data[index].estado),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () =>
                        _goToDetails(context, snapshot.data[index].pedidoID),
                  ),
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
