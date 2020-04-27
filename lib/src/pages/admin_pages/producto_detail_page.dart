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
  TextEditingController _nombreController;
  TextEditingController _descripcionController;
  TextEditingController _precioController;
  TextEditingController _itemDescripcionController;
  TextEditingController _itemCantPrecController;

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
                title: Text(_nombreController.text),
                subtitle: Text('Nombre'),
                leading: Icon(Icons.edit),
                onTap: () => _editData(
                    'Nombre', _nombreController, context, 'N'),
              ),
            ),
            Expanded(
              flex: 1,
              child: ListTile(
                title: Text(_descripcionController.text),
                subtitle: Text('Descripcion'),
                leading: Icon(Icons.edit),
                onTap: () => _editData('Descripcion', _descripcionController,
                    context, 'D'),
              ),
            ),
            producto.productoActual.precioUnitario == 0.0
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
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: TitleText(
                  text: 'Items',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: producto.productoActual.concreto.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                        producto.productoActual.concreto[index].descripcion),
                    subtitle: Text('\$' +
                        producto.productoActual.concreto[index].precioTotal
                            .toString()),
                    leading: Icon(Icons.edit),
                    onTap: () {
                      _itemDescripcionController.text = producto.productoActual.concreto[index].descripcion;
                      _itemCantPrecController.text = producto.productoActual.precioUnitario == 0 ?  producto.productoActual.concreto[index].precioTotal.toString() : producto.productoActual.concreto[index].cantidad.toString();
                      _editItems(context, index);
                    }
                  );
                },
              ),
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
                      keyboardType: controller == _precioController
                          ? TextInputType.number
                          : TextInputType.text,
                      inputFormatters: controller == _precioController
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

  _editItems(context, index) {
  ProductoNotifier prod = Provider.of<ProductoNotifier>(context, listen: false);
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
                      text: 'Descripcion',
                      fontSize: 15,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: _itemDescripcionController,
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: TitleText(
                      text: prod.productoActual.precioUnitario == 0
                          ? 'Precio'
                          : 'Cantidad',
                      fontSize: 15,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                      controller: _itemCantPrecController,
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
              onPressed: () => _saveItemData(context, contex, index)),
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

  _saveItemData(context, contex, index) {
    ProductoNotifier prod = Provider.of<ProductoNotifier>(context, listen: false);
    prod.setItemData(_itemDescripcionController.text,
        double.parse(_itemCantPrecController.text.toString()), index);
    _itemDescripcionController.clear();
    _itemCantPrecController.clear();
    Navigator.pop(contex);
  }

  _fillControllerData(ProductoNotifier producto) {
    _itemDescripcionController = TextEditingController();
    _itemCantPrecController = TextEditingController();
    _nombreController =
        TextEditingController(text: producto.productoActual.nombre);
    _descripcionController =
        TextEditingController(text: producto.productoActual.descripcion);
    _precioController = TextEditingController(
        text: producto.productoActual.precioUnitario.toString());
  }

  _setHabilitado(ProductoNotifier producto) {
    producto.setHabilitado();
  }
}
