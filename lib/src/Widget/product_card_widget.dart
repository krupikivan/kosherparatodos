import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/models/product.dart';
import 'package:kosherparatodos/src/pages/home_pages/pedido_pages/new_detalle_pedido.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class ProductCardWidget extends StatelessWidget {
  final Producto producto;

  const ProductCardWidget({Key key, this.producto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => new NewDetallePedido(
                  producto: producto,
                )));
      },
      child: Card(
        color: MyTheme.Colors.dark,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
                child: Image.network(producto.imagen, fit: BoxFit.scaleDown)),
            Positioned(
                child: FittedBox(
                    // fit: BoxFit.contain,
                    alignment: Alignment.bottomLeft,
                    child: Text(producto.nombre,
                        style: TextStyle(
                            color: MyTheme.Colors.light,
                            fontSize: 30,
                            fontWeight: FontWeight.bold)))),
          ],
        ),
      ),
    );
  }

  // _displayDialog(BuildContext context) async {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text('Cargar producto'),
  //           content: new SingleChildScrollView(
  //               child: new Material(
  //                   child: new MyDialogContent(
  //             onProduct: producto,
  //           ))),
  //           actions: <Widget>[
  //             Center(
  //               child: StreamBuilder<int>(
  //                   stream: blocNewPedido.getCantidad,
  //                   builder: (context, snapshot) {
  //                     return new FlatButton(
  //                       child: new Text('Agregar al pedido'),
  //                       onPressed: () {
  //                         if (snapshot.hasData) {
  //                           blocNewPedido.onNewDetalle(producto, snapshot.data);
  //                           Navigator.pop(context);
  //                         }
  //                       },
  //                     );
  //                   }),
  //             )
  //           ],
  //         );
  //       });
  // }
}

// class MyDialogContent extends StatefulWidget {
//   final Producto onProduct;

//   const MyDialogContent({Key key, this.onProduct}) : super(key: key);
//   @override
//   _MyDialogContentState createState() => new _MyDialogContentState(onProduct);
// }

// class _MyDialogContentState extends State<MyDialogContent> {
//   // TextEditingController _textFieldController = TextEditingController();
//   final Producto onProduct;
//   int _cantSelected;

//   _MyDialogContentState(this.onProduct);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Text('Kilos:'),
//             DropdownButton<int>(
//               items: onProduct.opcionCantidad
//                   .map((number) => DropdownMenuItem<int>(
//                         child: Text(number.toString()),
//                         value: number,
//                       ))
//                   .toList(),
//               onChanged: (int value) {
//                 blocNewPedido.addCantidad(value);
//                 setState(() {
//                   _cantSelected = value;
//                 });
//               },
//               value: _cantSelected,
//               isExpanded: false,
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
