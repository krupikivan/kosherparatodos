import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/categoria_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

//Esta clase me muestra las sub categorias si tienen ancestros

class SubcategoriaCardWidget extends StatelessWidget {
  final CategoriaNotifier categoria;
  final ProductoNotifier producto;
  final int index;

  const SubcategoriaCardWidget(
      {Key key, this.categoria, this.producto, this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        categoria.categoriaHijoSelected = categoria.categoriaHijoList[index];
        producto.getProductos(categoria.categoriaHijoSelected.categoriaID);
      },
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(categoria.categoriaHijoList[index].nombre,
                style: categoria.categoriaHijoSelected ==
                        categoria.categoriaHijoList[index]
                    ? TextStyle(
                        fontWeight: FontWeight.w900,
                        color: MyTheme.Colors.primary)
                    : TextStyle(fontWeight: FontWeight.w300)),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
