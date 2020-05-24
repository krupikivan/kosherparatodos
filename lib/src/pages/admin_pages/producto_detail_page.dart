import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kosherparatodos/src/Widget/show_toast.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';
import 'package:provider/provider.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class ProductoDetailPage extends StatelessWidget {
//   @override
//   _ProductoDetailPageState createState() => _ProductoDetailPageState();
// }

// class _ProductoDetailPageState extends State<ProductoDetailPage> {
  TextEditingController _descripcionController;
  TextEditingController _stockController;
  TextEditingController _precioController;
  TextEditingController _umController;

  @override
  Widget build(context) {
    ProductoNotifier producto = Provider.of<ProductoNotifier>(context);
    _fillControllerData(producto);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.Colors.dark,
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: TitleText(
                  text: 'Datos del producto',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: ListTile(
                title: Text(_descripcionController.text),
                subtitle: Text('Descripcion'),
                leading: Icon(Icons.edit),
                onTap: () => _editData(
                    'Descripcion', _descripcionController, context, 'D'),
              ),
            ),
            Expanded(
              flex: 1,
              child: ListTile(
                title: Text(_umController.text),
                subtitle: Text('Unidad medida'),
                leading: Icon(Icons.edit),
                onTap: () => _editData(
                    'Unidad Medida', _umController, context, 'UM'),
              ),
            ),
            Expanded(
              flex: 1,
              child: ListTile(
                title: Text(_stockController.text),
                subtitle: Text('Stock'),
                leading: Icon(Icons.edit),
                onTap: () => _editData('Stock', _stockController,
                    context, 'S'),
              ),
            ),
            producto.productoActual.precio == 0.0
                ? Container()
                : ListTile(
                    title: Text('\$' + _precioController.text.toString()),
                    subtitle: Text('Precio unitario'),
                    leading: Icon(Icons.edit),
                    onTap: () => _editData('Precio unitario', _precioController,
                        context, 'P'),
                  ),
            Expanded(
              flex: 1,
              child: _getEstado(context),
            ),
          ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _updateAllData(context),
        label: Text('Guardar'),
        backgroundColor: MyTheme.Colors.dark,
      ),
    );
  }

  Widget _getEstado(context) {
    ProductoNotifier producto = Provider.of<ProductoNotifier>(context, listen: false);
    return ListTile(
      title: TitleText(
        text: producto.productoActual.habilitado == true
            ? 'Habilitado para el cliente'
            : 'Deshabilitado para el cliente',
        color: MyTheme.Colors.dark,
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

  _updateAllData(context) {
    try{
      Provider.of<ProductoNotifier>(context, listen: false).updateAllData();
    Navigator.pop(context);
    ShowToast().show('Listo!', 5);
    }catch (e){
    ShowToast().show('Error!', 5);
    }
  }

  _editData(name, controller, context, tipo) {
    showDialog(
      context: context,
      builder: (contex) => AlertDialog(
        content: Container(
          padding: EdgeInsets.only(top: 10),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              TitleText(
                text: 'Editando',
                fontSize: 18,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: TitleText(
                      text: name,
                      fontSize: 15,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      keyboardType: controller == _precioController || controller == _stockController
                          ? TextInputType.number
                          : TextInputType.text,
                      inputFormatters: controller == _precioController || controller == _stockController
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
              child: Text("Guardar"),
              onPressed: () => _saveData(contex, context, tipo, controller)),
          FlatButton(
            child: Text("Volver"),
            onPressed: () => Navigator.pop(contex),
          ),
        ],
      ),
    );
  }

  _saveData(contex, context, tipo, controller) {
    Provider.of<ProductoNotifier>(context, listen: false).setData(tipo, controller.text);
    Navigator.pop(contex);
  }

  _fillControllerData(ProductoNotifier producto) {
    _descripcionController =
        TextEditingController(text: producto.productoActual.descripcion);
    _umController =
        TextEditingController(text: producto.productoActual.unidadMedida);
    _stockController =
        TextEditingController(text: producto.productoActual.stock.toString());
    _precioController = TextEditingController(
        text: producto.productoActual.precio.toString());
  }

  _setHabilitado(ProductoNotifier producto) {
    producto.setHabilitado();
  }
}
