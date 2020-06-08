import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/categoria_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;
import 'package:kosherparatodos/src/Widget/new_categoria_on_producto_checkbox.dart';
import 'package:provider/provider.dart';

class NewProducto extends StatefulWidget {
  @override
  _NewProductoState createState() => _NewProductoState();
}

class _NewProductoState extends State<NewProducto> {
  TextEditingController _codigoController;
  TextEditingController _descripcionController;
  TextEditingController _precioController;
  TextEditingController _stockController;
  TextEditingController _unidadMedidaController;

  bool _habilitado;

  @override
  void initState() {
    _codigoController = TextEditingController();
    _descripcionController = TextEditingController();
    _precioController = TextEditingController();
    _stockController = TextEditingController();
    _unidadMedidaController = TextEditingController();
    _habilitado = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<CategoriaNotifier>(context, listen: false).getAllCategorias;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.Colors.accent,
        title: const Text('Nuevo producto'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 20),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            _getRow('Codigo:', _codigoController, false),
            _getRow('Descripcion:', _descripcionController, false),
            _getRow('Precio: \$', _precioController, true),
            _getRow('Stock', _stockController, true),
            _getRow('Unidad Mediad:', _unidadMedidaController, false),
            _getHabilitado(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addProduct(context),
        label: const Text('Agregar'),
        backgroundColor: MyTheme.Colors.accent,
      ),
    );
  }

  Widget _getRow(name, controller, isNum) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: TitleText(
              text: name as String,
              fontSize: 15,
            ),
          ),
          Expanded(
            flex: 2,
            child: TextField(
              onChanged: _setProductData(),
              enabled: true,
              controller: controller as TextEditingController,
              inputFormatters: isNum == true
                  ? [WhitelistingTextInputFormatter.digitsOnly]
                  : null,
              keyboardType: isNum == true ? TextInputType.number : null,
            ),
          ),
        ],
      ),
    );
  }

  // Widget _viewItems() {
  //   return Expanded(
  //     flex: 2,
  //     child: ListView.builder(
  //         physics: ScrollPhysics(),
  //         shrinkWrap: true,
  //         itemCount: _categoriaList.length,
  //         itemBuilder: (BuildContext context, int index) => ListTile(
  //               title: Text(_categoriaList[index].nombre),
  //               leading: IconButton(
  //                   icon: Icon(
  //                     Icons.clear,
  //                     color: Colors.red,
  //                   ),
  //                   onPressed: () {
  //                     _categoriaList.removeAt(index);
  //                     setState(() {});
  //                   }),
  //             )),
  //   );
  // }

  _setProductData() {
    final ProductoNotifier producto =
        Provider.of<ProductoNotifier>(context, listen: false);
    final Producto nuevo = Producto.fromTextEditingController(
      codigo: _codigoController.text,
      descripcion: _descripcionController.text,
      precio: _precioController.text != ""
          ? double.parse(_precioController.text)
          : 0,
      stock: _stockController.text != "" ? int.parse(_stockController.text) : 0,
      unidadMedida: _unidadMedidaController.text,
      habilitado: _habilitado,
    );
    producto.creatingProducto(nuevo);
  }

  Widget _getHabilitado() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TitleText(
          text: _habilitado == true ? 'Disponible' : 'No disponible',
          fontSize: 15,
        ),
        IconButton(
          icon: Icon(
            Icons.check_circle,
            color: _habilitado == true ? Colors.green : Colors.red,
          ),
          onPressed: () => _changeBool(),
        ),
        const CategoriaCheckboxWidget(
          esProducto: true,
        ),
      ],
    );
  }

  void _changeBool() {
    if (_habilitado == true) {
      _habilitado = false;
      setState(() {});
    } else {
      _habilitado = true;
      setState(() {});
    }
  }

  void _addProduct(BuildContext context) {
    _setProductData();
    Provider.of<ProductoNotifier>(context, listen: false).addNewProducto();
    Navigator.pop(context);
  }
}
