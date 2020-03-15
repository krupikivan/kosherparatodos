import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/models/product.dart';
import 'package:kosherparatodos/src/pages/home_pages/bloc/new_pedido_bloc.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class AddRemoveButton extends StatelessWidget {
  const AddRemoveButton({Key key, this.icon, this.index, this.producto, this.action}) : super(key: key);

  final IconData icon;
  final int index;
  final Producto producto;
  final String action;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      elevation: 1.0,
      shape: CircleBorder(),
      fillColor: MyTheme.Colors.dark,
      onPressed: () => action == 'add' ? blocNewPedido.addingCurrentDetalle(producto, index) : blocNewPedido.removeCurrentDetalle(producto, index),
      child: Icon(
        icon,
        color: Colors.white,
        size: 15.0,
      ),
      constraints: BoxConstraints.tightFor(
        width: 36.0,
        height: 36.0,
      ),
    );
  }
}
