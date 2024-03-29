import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/categoria_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';
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
        if (esProducto) {
          categoria.getHijos();
        }
        showDialog(
            context: context,
            builder: (BuildContext context) => CategoriaDialog(
                  categoria: categoria,
                  producto: producto,
                  esProducto: esProducto,
                ));
      },
      textColor: Theme.of(context).primaryColor,
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
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width / 2,
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: <Widget>[
            TitleText(
              text: 'Agregar categoria',
            ),
            Expanded(
              flex: 4,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: widget.esProducto
                    ? widget.categoria.categoriaHijoList.length
                    : widget.categoria.categoriaPadreList.length,
                itemBuilder: (BuildContext context, int index) =>
                    CheckboxListTile(
                  value: (widget.esProducto
                          ? widget.categoria.categoriaHijoList[index].selected
                          : widget
                              .categoria.categoriaPadreList[index].selected) ??
                      false,
                  onChanged: (bool val) {
                    widget.esProducto
                        ? val
                            ? widget.producto.categoriaString.add(widget
                                .categoria.categoriaHijoList[index].categoriaID)
                            : widget.producto.categoriaString.remove(widget
                                .categoria.categoriaHijoList[index].categoriaID)
                        : val
                            ? widget.categoria.categoriaString.add(widget
                                .categoria
                                .categoriaPadreList[index]
                                .categoriaID)
                            : widget.categoria.categoriaString.remove(widget
                                .categoria
                                .categoriaPadreList[index]
                                .categoriaID);
                    widget.categoria.changeSelected(
                        widget.esProducto
                            ? widget
                                .categoria.categoriaHijoList[index].categoriaID
                            : widget.categoria.categoriaPadreList[index]
                                .categoriaID,
                        val,
                        widget.esProducto);
                    setState(() {});
                  },
                  title: Text(widget.esProducto
                      ? widget.categoria.categoriaHijoList[index].nombre
                      : widget.categoria.categoriaPadreList[index].nombre),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text(
            "Volver",
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
