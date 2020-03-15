import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/pages/home_pages/bloc/user_data_bloc.dart';
import 'package:kosherparatodos/src/pages/pedido_pages/order_details_page.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class HistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<List<Pedido>>(
          stream: blocUserData.getPedidos,
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                  child: CircularProgressIndicator(
                valueColor:
                    new AlwaysStoppedAnimation<Color>(MyTheme.Colors.dark),
              ));
            else
              return ListView.separated(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(_getFecha(snapshot.data[index].fecha) +
                        ' - Total: \$ ' +
                        snapshot.data[index].total.toString()),
                    subtitle: Text(
                      _getEstado(snapshot.data[index].estado),
                      style: TextStyle(
                          color: snapshot.data[index].estado == Estado.PAGADO
                              ? MyTheme.Colors.check
                              : MyTheme.Colors.warning),
                    ),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () => _goToDetails(context, snapshot.data[index].idPedido),
                  );
                },
                separatorBuilder: (context, index) => Divider(
                  color: Colors.black,
                ),
              );
          }),
    );
  }

  _getFecha(Timestamp fecha) {
    DateTime date =
        new DateTime.fromMillisecondsSinceEpoch(fecha.millisecondsSinceEpoch);
    return 'Fecha: ${date.day}/${date.month}/${date.year}';
  }

  _getEstado(Estado estado) {
    return estado == Estado.PAGADO ? 'Pagado' : 'No Pagado';
  }

  _goToDetails(context, uid) {
    blocUserData.getDetallePedido(uid);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OrderDetailsPage(
                  uid: uid,
                )));
  }
}
