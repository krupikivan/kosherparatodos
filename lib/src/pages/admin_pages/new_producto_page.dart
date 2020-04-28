import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
import 'package:kosherparatodos/src/models/producto_concreto.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;
import 'package:provider/provider.dart';

class NewProducto extends StatefulWidget {
  @override
  _NewProductoState createState() => _NewProductoState();
}

class _NewProductoState extends State<NewProducto> {
  TextEditingController _nombreController;
  TextEditingController _descripcionController;
  TextEditingController _precioController;
  TextEditingController _nuevoDescConcreto;
  TextEditingController _nuevoCantConcreto;
  TextEditingController _nuevoPrecioConcreto;

  List<ProductoConcreto> _concretoList;

  bool _habilitado;

  bool _precioEnable;

  @override
  void initState() {
    _nombreController = TextEditingController();
    _descripcionController = TextEditingController();
    _precioController = TextEditingController();
    _nuevoDescConcreto = TextEditingController();
    _nuevoCantConcreto = TextEditingController();
    _nuevoPrecioConcreto = TextEditingController();
    _concretoList = [];
    _habilitado = false;
    _precioEnable = false;
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
            _getRow('Nombre:', _nombreController, true, false),
            _getRow('Descripcion:', _descripcionController, true, false),
            _getRow('Precio: \$', _precioController, _precioEnable, true),
            _getHabilitado(),
            _concretoList.isEmpty ? Container() : _viewItems(),
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

  Widget _getRow(name, controller, enabled, setEnable) {
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
                enabled: enabled,
                controller: controller,
              ),
            ),
            setEnable == false ? Container() : IconButton(
              icon: Icon(
                Icons.check_circle,
                color: enabled == true ? Colors.green : Colors.grey,
              ),
              onPressed: () => _changePrecioEnable(),
            ),
          ],
        ),
      ),
    );
  }

  _addConcreto() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Container(
          height: MediaQuery.of(context).size.height / 3,
          padding: EdgeInsets.only(top: 20),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              TitleText(
                text: 'Agregar item',
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
                      controller: _nuevoDescConcreto,
                    ),
                  ),
                ],
              ),
               _precioEnable == false
                  ? Container() :
                  Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: TitleText(
                      text: 'Cantidad',
                      fontSize: 15,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: _nuevoCantConcreto,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                ],
              ),
              _precioEnable == true
                  ? Container()
                  : Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: TitleText(
                            text: 'Precio',
                            fontSize: 15,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _nuevoPrecioConcreto,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text("Agregar"),
            onPressed: () => _addToList(context),
          ),
          FlatButton(
            child: Text("Volver"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  _addToList(context) {
    ProductoConcreto con = new ProductoConcreto();
    con.descripcion = _nuevoDescConcreto.text;
    con.cantidad = !_precioEnable ? 0 : int.parse(_nuevoCantConcreto.text);
    con.precioTotal = _precioEnable ? con.cantidad * double.parse(_precioController.text) : double.parse(_nuevoPrecioConcreto.text);
    _concretoList.add(con);
    _nuevoDescConcreto.clear();
    _nuevoCantConcreto.clear();
    _nuevoPrecioConcreto.clear();
    setState(() {});
    Navigator.pop(context);
  }

  Widget _viewItems() {
    return Expanded(
      flex: 2,
      child: ListView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemCount: _concretoList.length,
          itemBuilder: (BuildContext context, int index) => ListTile(
                title: Text(_concretoList[index].descripcion),
                subtitle:
                    Text('\$' + _concretoList[index].precioTotal.toString()),
                leading: IconButton(
                    icon: Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      _concretoList.removeAt(index);
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
          OutlineButton(
            textColor: MyTheme.Colors.dark,
            onPressed: () => _addConcreto(),
            child: Text('Agregar item'),
          ),
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

  _changePrecioEnable() {
    if (_precioEnable == true) {
      _precioEnable = false;
      _precioController.clear();
      setState(() {});
    } else {
      _precioEnable = true;
      setState(() {});
    }
  }

  _addProduct(context) {
    Provider.of<ProductoNotifier>(context, listen: false).addNewProducto(
      _nombreController.text,
      _descripcionController.text,
      _precioEnable ? double.parse(_precioController.text) : 0,
      _habilitado,
      _concretoList,
    );
    Navigator.pop(context);
  }
}
