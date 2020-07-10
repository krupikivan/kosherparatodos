import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/export.dart';
import 'package:kosherparatodos/src/Widget/show_toast.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/widgets/export.dart';
import 'package:provider/provider.dart';

class ProductoDetailPage extends StatelessWidget {
  TextEditingController _codigoController;
  TextEditingController _descripcionController;
  TextEditingController _stockController;
  TextEditingController _precioController;
  TextEditingController _umController;
  final String image;

  ProductoDetailPage({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductoNotifier producto = Provider.of<ProductoNotifier>(context);
    _fillControllerData(producto);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TitleText(
                  color: Colors.black,
                  text: 'Detalle del producto',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                Column(
                  children: [
                    GestureDetector(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(image),
                        radius: 40,
                      ),
                      onTap: () => null,
                    ),
                    Text("Imagen")
                  ],
                ),
              ],
            ),
          ),
          InputDataField(
              controller: _descripcionController,
              isNum: false,
              description: "Descripcion"),
          InputDataField(
            controller: _codigoController,
            isNum: false,
            description: 'Codigo',
          ),
          InputDataField(
            controller: _umController,
            isNum: false,
            description: 'Unidad de medida',
          ),
          InputDataField(
            controller: _stockController,
            isNum: true,
            description: 'Stock',
          ),
          InputDataField(
              controller: _precioController,
              isNum: true,
              description: 'Precio unitario,'),
          EstadoHabilitado(),
          // _getEstado(context),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _updateAllData(context),
        label: const Text('Guardar'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  // Widget _getEstado(BuildContext context) {
  //   final ProductoNotifier producto =
  //       Provider.of<ProductoNotifier>(context, listen: false);
  //   return ListTile(
  //     title: TitleText(
  //       text: producto.productoActual.habilitado == true
  //           ? 'Habilitado para el cliente'
  //           : 'Deshabilitado para el cliente',
  //       fontSize: 14,
  //       fontWeight: FontWeight.w500,
  //     ),
  //     leading: Switch(
  //         value: producto.productoActual.habilitado == true,
  //         onChanged: (val) => _setHabilitado(producto)),
  //   );
  // }

  void _updateAllData(BuildContext context) {
    try {
      Provider.of<ProductoNotifier>(context, listen: false).updateAllData();
      Navigator.pop(context);
      ShowToast().show('Listo!', 5);
    } catch (e) {
      ShowToast().show('Error!', 5);
    }
  }

  // void _saveData(BuildContext contex, BuildContext context, String tipo,
  //     TextEditingController controller) {
  //   Provider.of<ProductoNotifier>(context, listen: false)
  //       .setData(tipo, controller.text);
  //   Navigator.pop(contex);
  // }

  void _fillControllerData(ProductoNotifier producto) {
    _codigoController =
        TextEditingController(text: producto.productoActual.codigo);
    _descripcionController =
        TextEditingController(text: producto.productoActual.descripcion);
    _umController =
        TextEditingController(text: producto.productoActual.unidadMedida);
    _stockController =
        TextEditingController(text: producto.productoActual.stock.toString());
    _precioController =
        TextEditingController(text: producto.productoActual.precio.toString());
  }
}
