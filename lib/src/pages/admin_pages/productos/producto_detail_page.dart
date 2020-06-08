import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kosherparatodos/src/Widget/show_toast.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';
import 'package:provider/provider.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class ProductoDetailPage extends StatelessWidget {
  TextEditingController _codigoController;
  TextEditingController _descripcionController;
  TextEditingController _stockController;
  TextEditingController _precioController;
  TextEditingController _umController;

  @override
  Widget build(BuildContext context) {
    final ProductoNotifier producto = Provider.of<ProductoNotifier>(context);
    _fillControllerData(producto);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.Colors.accent,
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TitleText(
                  text: 'Datos del producto',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                CircleAvatar(
                  backgroundImage: NetworkImage(producto.productoActual.imagen),
                  radius: 40,
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(_codigoController.text),
            subtitle: const Text('Codigo'),
            leading: Icon(Icons.edit),
            onTap: () => _editData('Codigo', _codigoController, context, 'C'),
          ),
          ListTile(
            title: Text(_descripcionController.text),
            subtitle: const Text('Descripcion'),
            leading: Icon(Icons.edit),
            onTap: () =>
                _editData('Descripcion', _descripcionController, context, 'D'),
          ),
          ListTile(
            title: Text(_umController.text),
            subtitle: const Text('Unidad medida'),
            leading: Icon(Icons.edit),
            onTap: () =>
                _editData('Unidad Medida', _umController, context, 'UM'),
          ),
          ListTile(
            title: Text(_stockController.text),
            subtitle: const Text('Stock'),
            leading: Icon(Icons.edit),
            onTap: () => _editData('Stock', _stockController, context, 'S'),
          ),
          ListTile(
            title: Text('\$${_precioController.text}'),
            subtitle: const Text('Precio unitario'),
            leading: Icon(Icons.edit),
            onTap: () =>
                _editData('Precio unitario', _precioController, context, 'P'),
          ),
          _getEstado(context),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _updateAllData(context),
        label: const Text('Guardar'),
        backgroundColor: MyTheme.Colors.accent,
      ),
    );
  }

  Widget _getEstado(BuildContext context) {
    final ProductoNotifier producto =
        Provider.of<ProductoNotifier>(context, listen: false);
    return ListTile(
      title: TitleText(
        text: producto.productoActual.habilitado == true
            ? 'Habilitado para el cliente'
            : 'Deshabilitado para el cliente',
        color: MyTheme.Colors.accent,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      leading: IconButton(
          icon: Icon(
            Icons.check_circle,
            color: producto.productoActual.habilitado == true
                ? Colors.green
                : Colors.red,
          ),
          onPressed: () => _setHabilitado(producto)),
    );
  }

  void _updateAllData(BuildContext context) {
    try {
      Provider.of<ProductoNotifier>(context, listen: false).updateAllData();
      Navigator.pop(context);
      ShowToast().show('Listo!', 5);
    } catch (e) {
      ShowToast().show('Error!', 5);
    }
  }

  void _editData(String name, TextEditingController controller,
      BuildContext context, String tipo) {
    showDialog(
      context: context,
      builder: (contex) => AlertDialog(
        content: Container(
          padding: const EdgeInsets.only(top: 10),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              const TitleText(
                text: 'Editando',
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: TitleText(
                      text: name,
                      fontSize: 15,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: controller == _precioController ||
                              controller == _stockController
                          ? TextInputType.number
                          : TextInputType.text,
                      inputFormatters: controller == _precioController ||
                              controller == _stockController
                          ? [WhitelistingTextInputFormatter.digitsOnly]
                          : null,
                      controller: controller,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => _saveData(contex, context, tipo, controller),
            child: const Text("Guardar"),
          ),
          FlatButton(
            onPressed: () => Navigator.pop(contex),
            child: const Text('Volver'),
          ),
        ],
      ),
    );
  }

  void _saveData(BuildContext contex, BuildContext context, String tipo,
      TextEditingController controller) {
    Provider.of<ProductoNotifier>(context, listen: false)
        .setData(tipo, controller.text);
    Navigator.pop(contex);
  }

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

  void _setHabilitado(ProductoNotifier producto) {
    producto.setHabilitado();
  }
}
