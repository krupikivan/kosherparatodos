import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/pages/admin_pages/productos/new_producto_page.dart';
import 'package:kosherparatodos/src/pages/admin_pages/productos/producto_detail_page.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';
import 'package:provider/provider.dart';

class ProductosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<ProductoNotifier>(
        builder: (context, producto, _) => Column(
          children: <Widget>[
            Expanded(
              flex: 4,
                child: RefreshIndicator(
                child: ListView.separated(
                  itemBuilder: (BuildContext context, int index) => Dismissible(
                    background: Container(color: Colors.red,alignment: AlignmentDirectional.centerStart, padding: EdgeInsets.symmetric(horizontal: 20), child: Icon(Icons.delete, color: Colors.white,),),
                    key: Key(producto.productoList[index].productoID),
                    confirmDismiss: (direction) => _deleteProducto(producto.productoList[index].productoID, context),
                                      child: ListTile(
                      leading: Icon(Icons.list),
                      // title: Text(DateFormat("HH:mm - dd/MM/yyyy").format(pedido.pedidoList[index].fecha.toDate())),
                      title: Text(producto.productoList[index].descripcion),
                      onTap: () {
                        producto.productoActual = producto.productoList[index];
                        _goToDetails(context);
                      },
                      trailing: Icon(Icons.arrow_forward),
                    ),
                  ),
                  itemCount: producto.productoList.length,
                  separatorBuilder: (BuildContext context, int index) => Divider(
                    color: MyTheme.Colors.dark,
                  ),
                ),
                onRefresh: () => /*_refreshList(context)*/null,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: FloatingActionButton.extended(onPressed:()=> _addProducto(context), label: Text('Agregar producto'), backgroundColor: MyTheme.Colors.dark,))
          ],
        ),
      ),
    );
  }

Future<bool> _deleteProducto(String idPorducto, context1) async{
  return await showDialog(
      context: context1,
      builder: (context) => AlertDialog(
        content: Text("¿Esta seguro que desea cancelar el turno?"),
        actions: <Widget>[
          FlatButton(
            child: Text("Si"),
            onPressed: () {
              Provider.of<ProductoNotifier>(context1, listen: false).deleteProducto(idPorducto);
              Navigator.of(context).pop(true);
            } 
          ),
          FlatButton(
            child: Text("No"),
            onPressed: () {
              Navigator.of(context).pop(false);
            } 
          ),
        ],
      ),
    );
}

  _goToDetails(context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ProductoDetailPage()));
  }

  _addProducto(context){
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => NewProducto()));
  }

//   Future<void> _refreshList(context) async {
//     Provider.of<ProductoNotifier>(context, listen: false).getProductos();
// }
}
