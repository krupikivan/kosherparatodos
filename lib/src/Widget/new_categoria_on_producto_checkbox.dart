import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/categoria_notifier.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CategoriaCheckboxWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CategoriaNotifier categoria =
        Provider.of<CategoriaNotifier>(context);
    return OutlineButton(
      onPressed: () {
        showDialog(context: context, builder: (BuildContext context) => CategoriaDialog(categoria: categoria,));
      },
      textColor: MyTheme.Colors.dark,
      child: Text('Categorias'),
    );
  }
}

class CategoriaDialog extends StatefulWidget {
  CategoriaDialog({Key key, this.categoria}) : super(key: key);
final CategoriaNotifier categoria;
  @override
  _CategoriaDialogState createState() => _CategoriaDialogState(categoria);
}

class _CategoriaDialogState extends State<CategoriaDialog> {
  final CategoriaNotifier categoria;

  _CategoriaDialogState(this.categoria);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height / 2,
        padding: EdgeInsets.only(top: 20),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            TitleText(
              text: 'Agregar categoria',
              fontSize: 18,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: categoria.categoriaList.length,
                    itemBuilder: (BuildContext context, int index) =>
                        CheckboxListTile(
                      value: categoria.categoriaList[index].selected,
                      onChanged: (bool val) {
                        categoria.changeSelected(
                            categoria.categoriaList[index].idCategoria, val);
                            setState(() {
                              
                            });
                      },
                      title: Text(categoria.categoriaList[index].nombre),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Volver"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
