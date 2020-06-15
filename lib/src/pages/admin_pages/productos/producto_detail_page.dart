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
  final String image;

  ProductoDetailPage({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ProductoNotifier producto = Provider.of<ProductoNotifier>(context);
    _fillControllerData(producto);
    return Scaffold(
      appBar: AppBar(
      ),
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
                      
                      onTap: () => print("hola"),
                    ),
                    Text("Imagen")
                  ],
                ),

              ],
            ),
          ),

          Field(controller: _descripcionController, type: 'D', description: "Descripcion"),
          Field(controller: _codigoController, type: 'D', description: 'Codigo',),
          Field(controller: _umController, type: 'D', description: 'Unidad de medida',),
          Field(controller: _stockController, type: 'N', description: 'Stock',),
          Field(controller: _precioController, type: 'N', description: 'Precio unitario,'),

          _getEstado(context),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _updateAllData(context),
        label: const Text('Guardar'),
        backgroundColor: MyTheme.Colors.primary,
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
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      leading: 
      Switch( value:  producto.productoActual.habilitado == true, onChanged: (val) => _setHabilitado(producto)),
      
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

class Field extends StatelessWidget {
  const Field({
    Key key,
    @required TextEditingController controller,
    @required String type,
    @required String description,

  }) : _controller = controller, _type = type, _description = description, super(key: key);

  final TextEditingController _controller;
  final String _type;
  final String _description;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextField(
        decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none), filled: true, ),
                keyboardType: _type == 'N'
                    ? TextInputType.number
                    : TextInputType.text,
                inputFormatters: _type == 'N'
                    ? [WhitelistingTextInputFormatter.digitsOnly]
                    : null,
                controller: _controller,
              ),
      subtitle: Text(_description),
    );
  }
}
