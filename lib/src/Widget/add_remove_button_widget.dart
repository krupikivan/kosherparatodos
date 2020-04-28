import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/bloc/bloc.dart';
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
      onPressed: () => action == 'add' ? blocPedidoVigente.addingCurrentDetalle(producto, index) : blocPedidoVigente.removeDetalle(producto, index),
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
