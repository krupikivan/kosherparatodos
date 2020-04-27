import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/pages/home_pages/historial_page/order_details_page.dart';
import 'package:kosherparatodos/src/pages/home_pages/bloc/user_data_bloc.dart';
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
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      leading: 
                      snapshot.data[index].pagado == Estado.PAGADO
                        ? FaIcon(FontAwesomeIcons.moneyBillAlt, size: 35, color: MyTheme.Colors.check,)
                        : FaIcon(FontAwesomeIcons.moneyBillAlt, size: 35, color: MyTheme.Colors.yellowWarning,),
                      
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(DateFormat("dd/MM/yyyy").format(snapshot.data[index].fecha.toDate())),
                              Text('Total: \$ ' +
                              snapshot.data[index].total.toString()),
                        ],
                      ),
                      subtitle: Text(
                        
                        snapshot.data[index].estado


                        // style: TextStyle(
                        //     color: snapshot.data[index].pagado == Estado.PAGADO
                        //         ? MyTheme.Colors.check
                        //         : MyTheme.Colors.warning),
                      ),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () =>
                          _goToDetails(context, snapshot.data[index].idPedido),
                    ),
                  );
                },
                // separatorBuilder: (context, index) => Divider(
                //   color: Colors.black,
                // ),
              );
          }),
    );
  }

// ///TODO No se esta usando?
//   _getEstado(Estado estado) {
//     return estado == Estado.PAGADO ? 'Pagado' : 'No Pagado';
//   }

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
