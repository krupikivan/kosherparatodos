import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kosherparatodos/src/Widget/export.dart';
import 'package:kosherparatodos/src/Widget/shimmer_list_loading.dart';
import 'package:kosherparatodos/src/models/producto.dart';
import 'package:kosherparatodos/src/pages/admin_pages/productos/new_producto.dart';
import 'package:kosherparatodos/src/pages/admin_pages/productos/new_categoria.dart';
import 'package:kosherparatodos/src/pages/admin_pages/productos/producto_detail_page.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/categoria_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/widgets/export.dart';
import 'package:kosherparatodos/src/repository/firebase_storage.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';
import 'package:provider/provider.dart';

class ProductoListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Consumer<CategoriaNotifier>(
        builder: (context, categoria, _) => categoria.categoriaPadreList.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //Maneja solo las categorias padres
                  Container(
                    height: 40,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: categoria.categoriaPadreList.length,
                      itemBuilder: (context, int index) {
                        return CategoriaCardWidget(
                          producto: Provider.of<ProductoNotifier>(context),
                          categoria: categoria,
                          index: index,
                        );
                      },
                    ),
                  ),
                  categoria.categoriaHijoList.isEmpty
                      ? SizedBox()
                      //Maneja solo las categorias hijos que tienen ancestros
                      : Container(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categoria.categoriaHijoList.length,
                            itemBuilder: (context, int index) =>
                                Consumer<ProductoNotifier>(
                              builder: (context, producto, _) =>
                                  SubcategoriaCardWidget(
                                index: index,
                                categoria: categoria,
                                producto: producto,
                              ),
                            ),
                          ),
                        ),
                  //Muestra productos si se selecciono una categoria
                  _fillProductos(context),
                ],
              ),
      ),
      floatingActionButton: _bntExpanded(context),
    );
  }

  Widget _fillProductos(BuildContext context) {
    final producto = Provider.of<ProductoNotifier>(context);
    final storage = Provider.of<FireStorageService>(context, listen: false);
    return Expanded(
      flex: 2,
      child: ListView.builder(
        itemCount: producto.productoList.length,
        itemBuilder: (BuildContext context, int index) => FutureBuilder(
          future: storage.getImage(producto.productoList[index].imagen),
          builder: (context, snapshot) => !snapshot.hasData
              ? ShimmerListLoadingEffect()
              : ProductoCardWidget(
                  descripcion: producto.productoList[index].descripcion,
                  img: snapshot.data,
                  marca: producto.productoList[index].marca,
                  action: () {
                    producto.productoActual = producto.productoList[index];
                    _detalleProducto(
                        context, snapshot.data, producto.productoActual);
                  },
                ),
        ),
      ),
    );
  }

  void _detalleProducto(BuildContext context, image, Producto prod) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProductoDetailPage(
                  image: image,
                  producto: prod,
                )));
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
        SpeedDialChild(
          child: Icon(FontAwesomeIcons.cartPlus, color: Colors.white),
          backgroundColor: Theme.of(context).primaryColor,
          label: 'Agregar Producto',
          labelStyle: TextStyle(color: Theme.of(context).primaryColor),
          onTap: () => _addNewProducto(context),
        )
      ],
    );
  }
}
