import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';
import 'package:provider/provider.dart';

class EstadoHabilitado extends StatelessWidget {
  const EstadoHabilitado({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductoNotifier producto =
        Provider.of<ProductoNotifier>(context, listen: false);
    return ListTile(
      title: TitleText(
        text: producto.productoActual.habilitado == true
            ? 'Habilitado para el cliente'
            : 'Deshabilitado para el cliente',
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      leading: Switch(
          value: producto.productoActual.habilitado == true,
          onChanged: (val) => _setHabilitado(producto)),
    );
  }

  void _setHabilitado(ProductoNotifier producto) {
    producto.setHabilitado();
  }
}
