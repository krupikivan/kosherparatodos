import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/models/detalle_pedido.dart';
import 'package:kosherparatodos/src/pages/home_pages/bloc/new_pedido_bloc.dart';
// import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class NewItemWidget extends StatelessWidget {
  const NewItemWidget({Key key, this.item}) : super(key: key);
  final DetallePedido item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListTile(
          leading: IconButton(icon: Icon(Icons.remove), onPressed: ()=> blocNewPedido.removeOnPedido(item),),
          title: Text(item.concreto.descripcion),
          subtitle: Text(item.cantidad.toString() + ' unid.'),
          trailing: Container(
            width: 70,
            height: 70,
            alignment: Alignment.center,
            child: Text('\$${item.precioDetalle}'),
          )),
    );
  }
}
