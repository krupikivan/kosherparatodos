import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
import 'package:kosherparatodos/src/models/categoria.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;
import 'package:kosherparatodos/src/Widget/new_categoria_on_producto_checkbox.dart';
class NewProducto extends StatefulWidget {
  @override
  _NewProductoState createState() => _NewProductoState();
}

class _NewProductoState extends State<NewProducto> {
  TextEditingController _codigoController;
  TextEditingController _descripcionController;
  TextEditingController _precioController;

  List<Categoria> _categoriaList;

  bool _habilitado;


  @override
  void initState() {
    _codigoController = TextEditingController();
    _descripcionController = TextEditingController();
    _precioController = TextEditingController();
    _categoriaList = [];
    _habilitado = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.Colors.dark,
        title: Text('Nuevo producto'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          children: <Widget>[
            _getRow('Codigo:', _codigoController),
            _getRow('Descripcion:', _descripcionController),
            _getRow('Precio: \$', _precioController),
            _getHabilitado(),
            _categoriaList.isEmpty ? Container() : _viewItems(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addProduct(context),
        label: Text('Agregar'),
        backgroundColor: MyTheme.Colors.dark,
      ),
    );
  }

  Widget _getRow(name, controller) {
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: TitleText(
                text: name,
                fontSize: 15,
              ),
            ),
            Expanded(
              flex: 2,
              child: TextField(
                enabled: true,
                controller: controller,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _viewItems() {
    return Expanded(
      flex: 2,
      child: ListView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemCount: _categoriaList.length,
          itemBuilder: (BuildContext context, int index) => ListTile(
                title: Text(_categoriaList[index].nombre),
                leading: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _categoriaList.removeAt(index);
                      setState(() {});
                    }),
              )),
    );
  }

  Widget _getHabilitado() {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          TitleText(
            text:
                _habilitado == true ? 'Esta disponible' : 'No esta disponible',
            fontSize: 15,
          ),
          IconButton(
            icon: Icon(
              Icons.check_circle,
              color: _habilitado == true ? Colors.green : Colors.red,
            ),
            onPressed: () => _changeBool(),
          ),
           CategoriaCheckboxWidget(),
        ],
      ),
    );
  }

  _changeBool() {
    if (_habilitado == true) {
      _habilitado = false;
      setState(() {});
    } else {
      _habilitado = true;
      setState(() {});
    }
  }

  _addProduct(context) {
  //   Provider.of<ProductoNotifier>(context, listen: false).addNewProducto(
  //     _nombreController.text,
  //     _descripcionController.text,
  //     _precioEnable ? double.parse(_precioController.text) : 0,
  //     _habilitado,
  //     _concretoList,
  //   );
  //   Navigator.pop(context);
  }
}
