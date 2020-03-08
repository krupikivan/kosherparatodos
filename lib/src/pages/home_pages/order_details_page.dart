import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/models/detalle_pedido.dart';
import 'package:kosherparatodos/src/pages/home_pages/bloc/user_data_bloc.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({Key key, this.uid}) : super(key: key);
  final String uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.Colors.dark,
        title: Text("Detalle de pedido"),
      ),
          body: Container(
            child: StreamBuilder<List<DetallePedido>>(
            stream: blocUserData.getDetalle,
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
                  itemBuilder: (BuildContext context, int index) => ListTile(
                    title: Text(snapshot.data[index].name),
                    subtitle: Text(snapshot.data[index].cantidad.toString() + ' ' + snapshot.data[index].unidad),
                  ),
                );
            }),
      ),
    );
  }
}
