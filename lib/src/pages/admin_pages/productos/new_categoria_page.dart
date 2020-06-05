import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
import 'package:kosherparatodos/src/models/categoria.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/categoria_notifier.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;
import 'package:kosherparatodos/src/Widget/new_categoria_on_producto_checkbox.dart';
import 'package:provider/provider.dart';

class NewCategoria extends StatefulWidget {
  @override
  _NewCategoriaState createState() => _NewCategoriaState();
}

class _NewCategoriaState extends State<NewCategoria> {
  TextEditingController _nombreController;


  bool _esPadre;


  @override
  void initState() {
    _nombreController = TextEditingController();
    _esPadre = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<CategoriaNotifier>(context, listen: false).getAllCategorias();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.Colors.dark,
        title: Text('Nueva Categoria'),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.only(bottom: 20),
        child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          _getRow('Nombre:', _nombreController, false),
          _getHabilitado(),
        ],
          ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addCategoria(context),
        label: Text('Agregar'),
        backgroundColor: MyTheme.Colors.dark,
      ),
    );
  }

  Widget _getRow(name, controller, isNum) {
    return Padding(
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
            child: TextFormField(
              onChanged: _setCategoriaData(),
              enabled: true,
              controller: controller,
              inputFormatters: isNum == true ? [WhitelistingTextInputFormatter.digitsOnly] : null,
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

  _setCategoriaData(){
    var categoria = Provider.of<CategoriaNotifier>(context, listen: false);
    Categoria nuevo = new Categoria();
    nuevo.nombre = _nombreController.text;
    nuevo.esPadre = _esPadre;
    categoria.creatingCategoria(nuevo);
  }

  Widget _getHabilitado() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TitleText(
          text:
              _esPadre == true ? 'Es categoria padre' : 'No es categoria padre',
          fontSize: 15,
        ),
        IconButton(
          icon: Icon(
            Icons.check_circle,
            color: _esPadre == true ? Colors.green : Colors.red,
          ),
          onPressed: () => _changeBool(),
        ),
         _esPadre == false ? CategoriaCheckboxWidget(esProducto: false) : SizedBox(height: 1,),
      ],
    );
  }

  _changeBool() {
    if (_esPadre == true) {
      _esPadre = false;
      setState(() {});
    } else {
      _esPadre = true;
      setState(() {});
    }
  }

  _addCategoria(context) {
    _setCategoriaData();
    Provider.of<CategoriaNotifier>(context, listen: false).addNewCategoria();
    Navigator.pop(context);
  }
}
