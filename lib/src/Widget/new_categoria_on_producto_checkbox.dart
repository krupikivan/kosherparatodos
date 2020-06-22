import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/categoria_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CategoriaCheckboxWidget extends StatelessWidget {
  final bool esProducto;

  const CategoriaCheckboxWidget({Key key, this.esProducto}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final CategoriaNotifier categoria = Provider.of<CategoriaNotifier>(context);
    final ProductoNotifier producto = Provider.of<ProductoNotifier>(context);
    return OutlineButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (BuildContext context) => CategoriaDialog(
                  categoria: categoria,
                  producto: producto,
                  esProducto: esProducto,
                ));
      },
      textColor: MyTheme.Colors.primary,
      child: Text('Seleccionar Categorias'),
    );
  }
}

class CategoriaDialog extends StatefulWidget {
  CategoriaDialog({Key key, this.categoria, this.producto, this.esProducto})
      : super(key: key);
  final CategoriaNotifier categoria;
  final ProductoNotifier producto;
  final bool esProducto;
  @override
  _CategoriaDialogState createState() => _CategoriaDialogState();
}

class _CategoriaDialogState extends State<CategoriaDialog> {
  // final CategoriaNotifier categoria;
  // final ProductoNotifier producto;
  // final bool esProducto;

  // _CategoriaDialogState(this.categoria, this.producto, {this.esProducto});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width / 2,
        padding: EdgeInsets.only(top: 20),
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            TitleText(
              text: 'Agregar categoria',
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.categoria.categoriaList.length,
                    itemBuilder: (BuildContext context, int index) =>
                        CheckboxListTile(
                      value: widget.categoria.categoriaList[index].selected,
                      onChanged: (bool val) {
                        widget.esProducto == true
                            ? val == true
                                ? widget.producto.categoriaString.add(widget
                                    .categoria.categoriaList[index].categoriaID)
                                : widget.producto.categoriaString.remove(widget
                                    .categoria.categoriaList[index].categoriaID)
                            : val == true
                                ? widget.categoria.categoriaString.add(widget
                                    .categoria.categoriaList[index].categoriaID)
                                : widget.categoria.categoriaString.remove(widget
                                    .categoria
                                    .categoriaList[index]
                                    .categoriaID);
                        widget.categoria.changeSelected(
                            widget.categoria.categoriaList[index].categoriaID,
                            val);
                        setState(() {});
                      },
                      title: Text(widget.categoria.categoriaList[index].nombre),
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
          child: Text(
            "Volver",
            style: TextStyle(color: MyTheme.Colors.primary),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
