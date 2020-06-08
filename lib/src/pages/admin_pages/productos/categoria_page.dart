import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kosherparatodos/src/Widget/categorias_card_widget.dart';
import 'package:kosherparatodos/src/pages/admin_pages/productos/new_producto_page.dart';
import 'package:kosherparatodos/src/pages/admin_pages/productos/new_categoria_page.dart';
import 'package:kosherparatodos/src/pages/admin_pages/productos/producto_detail_page.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/categoria_notifier.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';
import 'package:provider/provider.dart';

class CategoriaPage extends StatelessWidget {
  /*@override
  _CategoriaPageState createState() => _CategoriaPageState();
}

class _CategoriaPageState extends State<CategoriaPage> {*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<CategoriaNotifier>(
        builder: (context, categoria, _) => categoria.categoriaPadreList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    // child: RefreshIndicator(
                    child: GridView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) =>
                          /*Dismissible(
                    background: Container(color: Colors.red,alignment: AlignmentDirectional.centerStart, padding: EdgeInsets.symmetric(horizontal: 20), child: Icon(Icons.delete, color: Colors.white,),),
                    key: Key(categoria.categoriaList[index].idCategoria),
                     confirmDismiss: (direction) => _deleteCategoria(categoria.categoriaList[index].idCategoria, context),
                      child: ListTile(
                      leading: Icon(Icons.list),
                      title: Text(categoria.categoriaList[index].nombre),
                      onTap: () {
                        _goToDetails(context);
                      },
                      trailing: Icon(Icons.arrow_forward),
                    ),
                   ),*/
                          CategoriaCardWidget(
                        categoria: categoria,
                        index: index,
                      ),
                      itemCount: categoria.categoriaPadreList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1),
                      //   color: MyTheme.Colors.dark,
                      // ),
                    ),
                    // onRefresh: () => _refreshList(context),
                    // ),
                  ),
                  Consumer<ProductoNotifier>(
                    builder: (context, producto, _) =>
                        categoria.categoriaHijoSelected == null
                            ? _fillCategoriasHijos(categoria, producto)
                            : _fillProductos(producto),
                  ),
                ],
              ),
      ),
      floatingActionButton: _bntExpanded(context),
    );
  }

  Widget _fillCategoriasHijos(
      CategoriaNotifier categoria, ProductoNotifier producto) {
    return Expanded(
        flex: 4,
        child: ListView.builder(
          itemCount: categoria.categoriaHijoList.length,
          itemBuilder: (BuildContext context, int index) => ListTile(
              title: Text(categoria.categoriaHijoList[index].nombre),
              leading: Icon(Icons.list),
              onTap: () {
                categoria.categoriaHijoSelected =
                    categoria.categoriaHijoList[index];
                producto
                    .getProductos(categoria.categoriaHijoSelected.categoriaID);
              }),
        ));
  }

  Widget _fillProductos(ProductoNotifier producto) {
    return Expanded(
        flex: 4,
        child: ListView.builder(
          itemCount: producto.productoList.length,
          itemBuilder: (BuildContext context, int index) => ListTile(
              title: Text(producto.productoList[index].descripcion),
              leading: Icon(Icons.list),
              onTap: () {
                producto.productoActual = producto.productoList[index];
                _detalleProducto(context);
              }),
        ));
  }

// Future<bool> _deleteCategoria(String idPorducto, context1) async{
//   return await showDialog(
//       context: context1,
//       builder: (context) => AlertDialog(
//         content: Text("¿Esta seguro que desea eliminar?"),
//         actions: <Widget>[
//           FlatButton(
//             child: Text("Si"),
//             onPressed: () {
//               Provider.of<ProductoNotifier>(context1, listen: false).deleteProducto(idPorducto);
//               Navigator.of(context).pop(true);
//             }
//           ),
//           FlatButton(
//             child: Text("No"),
//             onPressed: () {
//               Navigator.of(context).pop(false);
//             }
//           ),
//         ],
//       ),
//     );
// }

  void _detalleProducto(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProductoDetailPage()));
  }

  void _addNewProducto(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewProducto()));
  }

  void _addNewCategoria(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewCategoria()));
  }

  Widget _bntExpanded(BuildContext context) {
    return SpeedDial(
      marginRight: 15,
      marginBottom: 15,
      overlayOpacity: 0.3,
      overlayColor: MyTheme.Colors.white,
      heroTag: 'bntExpand',
      backgroundColor: MyTheme.Colors.accent,
      child: Icon(
        Icons.add,
        color: MyTheme.Colors.white,
      ),
      children: [
        SpeedDialChild(
          child: Icon(FontAwesomeIcons.listUl, color: MyTheme.Colors.white),
          backgroundColor: MyTheme.Colors.accent,
          label: 'Agregar Categoria',
          labelStyle: TextStyle(color: MyTheme.Colors.accent),
          onTap: () => _addNewCategoria(context),
        ),
        SpeedDialChild(
          child: Icon(FontAwesomeIcons.cartPlus, color: MyTheme.Colors.white),
          backgroundColor: MyTheme.Colors.accent,
          label: 'Agregar Producto',
          labelStyle: TextStyle(color: MyTheme.Colors.accent),
          onTap: () => _addNewProducto(context),
        )
      ],
    );
  }
}
