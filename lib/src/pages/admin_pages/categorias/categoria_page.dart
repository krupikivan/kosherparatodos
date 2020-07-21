import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kosherparatodos/src/pages/admin_pages/categorias/new_categoria.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/categoria_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/categorias/categoria_tile.dart';
import 'package:provider/provider.dart';

import '../../../models/categoria.dart';
import '../provider/categoria_notifier.dart';

class CategoriaPage extends StatelessWidget {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Consumer<CategoriaNotifier>(
          builder: (context, categoria, _) => categoria.categoriaList.isEmpty
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _getTitle('Categoria', context),
                        _getTitle('Tipo', context),
                      ],
                    ),
                    Divider(
                      color: Colors.grey[800],
                      thickness: 1,
                    ),
                    Expanded(
                      flex: 3,
                      child: ListView.builder(
                          itemCount: categoria.categoriaList.length,
                          itemBuilder: (BuildContext context, int index) =>
                              Column(
                                children: <Widget>[
                                  CategoriaTile(
                                    esPadre:
                                        categoria.categoriaList[index].esPadre,
                                    action: () => _showPopup(context,
                                        categoria.categoriaList[index]),
                                    name: categoria.categoriaList[index].nombre,
                                  ),
                                ],
                              )),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                    )
                  ],
                )),
      floatingActionButton: _bntExpanded(context),
    );
  }

  Widget _getTitle(String text, context) {
    return Text(
      text,
      style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20),
    );
  }

  void _addNewCategoria(BuildContext context) {
    Provider.of<CategoriaNotifier>(context, listen: false).clearListString();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewCategoria()));
  }

  _showPopup(context1, Categoria categoria) {
    controller.text = categoria.nombre;
    return showDialog(
      context: context1,
      builder: (BuildContext context) => AlertDialog(
        insetPadding: EdgeInsets.zero,
        title: Text(
          'Editar categoria',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Aceptar',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18)),
            onPressed: () {
              Provider.of<CategoriaNotifier>(context1, listen: false)
                  .changeCategoria(categoria, controller.text);
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('Cancelar',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18)),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        content: Container(
          padding: const EdgeInsets.only(top: 20),
          height: 80,
          width: MediaQuery.of(context).size.width / 1.3,
          child: TextField(
            controller: controller,
          ),
        ),
      ),
    );
  }

  Widget _bntExpanded(BuildContext context) {
    return SpeedDial(
      marginRight: 15,
      marginBottom: 15,
      overlayOpacity: 0.3,
      overlayColor: Colors.white,
      heroTag: 'bntExpand',
      backgroundColor: Theme.of(context).primaryColor,
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
      children: [
        SpeedDialChild(
          child: Icon(FontAwesomeIcons.listUl, color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          label: 'Agregar Categoria',
          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
          onTap: () => _addNewCategoria(context),
        ),
      ],
    );
  }
}
