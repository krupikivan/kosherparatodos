import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/add_remove_button_widget.dart';
import 'package:kosherparatodos/src/models/detalle_pedido.dart';
import 'package:kosherparatodos/src/models/product.dart';
import 'package:kosherparatodos/src/pages/home_pages/bloc/new_pedido_bloc.dart';
import 'package:kosherparatodos/src/pages/home_pages/bloc/product_data_bloc.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class NewDetallePedido extends StatelessWidget {
  final Producto producto;

  const NewDetallePedido({Key key, this.producto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    blocProductData.getProductoConcretoList(producto.idProducto);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.Colors.dark,
        title: Text(producto.nombre),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Text(
              producto.descripcion,
              style: TextStyle(fontSize: 20),
            ),
            ///TODO funciona pero no es asi
            Expanded(
                child: StreamBuilder<List<Producto>>(
                stream: blocProductData.getProducts,
                builder: (context, snapshot) {
                  if(producto.concreto == null) return Center(
                    child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(MyTheme.Colors.dark),
                ),
                  ); else
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: producto.concreto.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          StreamBuilder<List<DetallePedido>>(
                            stream: blocNewPedido.getDetalle,
                            builder: (context, snapshot) {
                              if(!snapshot.hasData || snapshot.data.isEmpty) return Text('');
                              else if(snapshot.data.any((value) => value.concreto.id == producto.concreto[index].id))
                              return Text(snapshot.data.firstWhere((value) => value.concreto.id == producto.concreto[index].id).cantidad.toString());
                              else return Text('');
                            }
                          ),
                          // Text(producto.concreto[index].cantidadPedido.toString()),
                          Text(producto.concreto[index].descripcion),
                          Row(
                            children: <Widget>[
                              AddRemoveButton(
                                icon: Icons.add,
                                index: index,
                                producto: producto,
                                action: 'add',
                              ),
                              AddRemoveButton(
                                icon: Icons.remove,
                                index: index,
                                producto: producto,
                                action: 'remove',
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  );
                }
              ),
            ),
            // Container(
            //   child: StreamBuilder<List<DetallePedido>>(
            //       stream: blocNewPedido.getDetalle,
            //       builder: (context, snapshot) {
            //         if (!snapshot.hasData || snapshot.data.length == 0)
            //           return Container();
            //         return ListView.builder(
            //           shrinkWrap: true,
            //           itemCount: snapshot.data.length,
            //           itemBuilder: (BuildContext context, int index) {
            //             return ListTile(
            //               title: Text(snapshot.data[index].descripcion),
            //               subtitle: Text(
            //                   snapshot.data[index].unidades.toString() +
            //                       ' ' +
            //                       snapshot.data[index].bulto),
            //             );
            //           },
            //         );
            //       }),
            // ),
            // FlatButton(
            //     onPressed: () {
            //       // blocNewPedido.onNewDetalle(producto);
            //       Navigator.pop(context);
            //     },
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(15)),
            //     color: MyTheme.Colors.dark,
            //     child: Container(
            //       alignment: Alignment.center,
            //       padding: EdgeInsets.symmetric(vertical: 12),
            //       child: Text(
            //         'Agregar al pedido',
            //         style: TextStyle(color: MyTheme.Colors.light),
            //       ),
            //     ))
          ],
        ),
      ),
    );
  }
}
