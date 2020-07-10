import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/categoria_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';

//Esta clase me muestra las categorias padres que no tienen ancestros
class CategoriaCardWidget extends StatelessWidget {
  final CategoriaNotifier categoria;
  final ProductoNotifier producto;
  final int index;

  const CategoriaCardWidget(
      {Key key, this.categoria, this.index, this.producto})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        categoria.setPadreSelected(categoria.categoriaPadreList[index]);
        producto.clearProductoList();
      },
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(categoria.categoriaPadreList[index].nombre,
                style: categoria.categoriaPadreSelected ==
                        categoria.categoriaPadreList[index]
                    ? TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).primaryColor)
                    : TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
          ),
          SizedBox(
            width: 10,
            height: 10,
          ),
        ],
      ),
    );
  }
}
