import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/export.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/categoria_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/widgets/export.dart';
import 'package:provider/provider.dart';

class NewProducto extends StatefulWidget {
  @override
  _NewProductoState createState() => _NewProductoState();
}

class _NewProductoState extends State<NewProducto> {
  TextEditingController _codigoController;
  TextEditingController _descripcionController;
  TextEditingController _marcaController;
  TextEditingController _precioController;
  TextEditingController _stockController;
  TextEditingController _unidadMedidaController;

  bool _habilitado;

  @override
  void initState() {
    _codigoController = TextEditingController();
    _descripcionController = TextEditingController();
    _marcaController = TextEditingController();
    _precioController = TextEditingController();
    _stockController = TextEditingController();
    _unidadMedidaController = TextEditingController();
    _habilitado = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final CategoriaNotifier cateNot =
    //     Provider.of<CategoriaNotifier>(context, listen: false);
    // cateNot.getAllCategoriasHijos();
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 20),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: TitleText(
                color: Colors.black,
                text: 'Agregar nuevo Producto',
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            InputDataField(
                controller: _codigoController,
                isNum: false,
                description: 'Codigo'),
            InputDataField(
                controller: _descripcionController,
                isNum: false,
                description: 'Descripcion'),
            InputDataField(
                controller: _marcaController,
                isNum: false,
                description: 'Marca'),
            InputDataField(
                controller: _precioController,
                isNum: true,
                description: 'Precio'),
            InputDataField(
                controller: _stockController,
                isNum: true,
                description: 'Stock'),
            InputDataField(
                controller: _unidadMedidaController,
                isNum: false,
                description: 'Unidad Mediad'),
            ListTile(
              title: TitleText(
                text: _habilitado
                    ? 'Habilitado para el cliente'
                    : 'Deshabilitado para el cliente',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              leading:
                  Switch(value: _habilitado, onChanged: (val) => _changeBool()),
            ),
            CategoriaCheckboxWidget(
              esProducto: true,
            ),
          ],
        ),
      ),
      floatingActionButton: Consumer<CategoriaNotifier>(
        builder: (context, cate, _) => FloatingActionButton.extended(
          onPressed: () =>
              _validateInputData() && cate.categoriaString.isNotEmpty
                  ? _addProduct(context)
                  : ShowToast().show('Faltan datos', 5),
          label: const Text('Agregar'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      ),
    );
  }

  bool _validateInputData() {
    if (_codigoController.text != "" &&
        _descripcionController.text != "" &&
        _marcaController.text != "" &&
        _precioController.text != "" &&
        _stockController.text != "" &&
        _unidadMedidaController.text != "") {
      return true;
    }
    return false;
  }

  _setProductData() {
    final ProductoNotifier producto =
        Provider.of<ProductoNotifier>(context, listen: false);
    final Producto nuevo = Producto.fromTextEditingController(
      codigo: _codigoController.text,
      descripcion: _descripcionController.text,
      marca: _marcaController.text,
      precio: _precioController.text != ""
          ? double.parse(_precioController.text)
          : 0,
      stock: _stockController.text != "" ? int.parse(_stockController.text) : 0,
      unidadMedida: _unidadMedidaController.text,
      habilitado: _habilitado,
    );
    producto.creatingProducto(nuevo);
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
