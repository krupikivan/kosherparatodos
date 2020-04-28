import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kosherparatodos/src/Widget/item_detalle_pedido_widget.dart';
import 'package:kosherparatodos/src/Widget/show_toast.dart';
import 'package:kosherparatodos/src/Widget/title_text.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/bloc/bloc.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class DetallePedidoListPage extends StatelessWidget {
  Widget _addHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[_getRowText('Producto'), _getRowText('Total')],
      ),
    );
  }

  _getRowText(text) {
    return Text(text,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500));
  }

  Widget _productItems() {
    return StreamBuilder<Pedido>(
        stream: blocPedidoVigente.getPedido,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data.detallePedido == null)
            return Container();
          else
            return Expanded(
              child: ListView.builder(
                itemCount: snapshot.data.detallePedido.length,
                itemBuilder: (BuildContext context, int index) {
                  return ItemDetallePedidoWidget(
                    item: snapshot.data.detallePedido[index],
                  );
                },
              ),
            );
        });
  }

  Widget _price() {
    return StreamBuilder<Pedido>(
        stream: blocPedidoVigente.getPedido,
        builder: (context, snapshot) {
          double total = 0;
          if (snapshot.hasData && snapshot.data.detallePedido != null) {
            snapshot.data.detallePedido.forEach((element) {
              total +=
                  element.precioDetalle != null ? element.precioDetalle : 0;
            });
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TitleText(
                text: 'Total del pedido: ${total.toString()}',
                color: MyTheme.Colors.dark,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ],
          );
        });
  }

  Widget _submitButton(BuildContext context) {
    return StreamBuilder<Pedido>(
        stream: blocPedidoVigente.getPedido,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            return Column(
              children: [
                FlatButton(
                    onPressed: () {
                      if(snapshot.data.total != 0.0){
                        blocPedidoVigente.savePedido();
                        ShowToast().show('Exito!', 5);
                      }else{
                        ShowToast().show('El pedido esta vacio', 5);
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: MyTheme.Colors.dark,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        snapshot.data.idPedido == null
                            ? 'Realizar pedido'
                            : 'Modificar pedido',
                        style: TextStyle(color: MyTheme.Colors.light),
                      ),
                    )),
                FlatButton(
                    onPressed: () => blocPedidoVigente.clearPedido(),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    color: MyTheme.Colors.dark,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                            'Cancelar',
                        style: TextStyle(color: MyTheme.Colors.light),
                      ),
                    )),
              ],
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.Colors.dark,
        title: Text("Detalle del Pedido"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            _addHeader(),
            _productItems(),
            Divider(
              thickness: 1,
              height: 70,
            ),
            _price(),
            SizedBox(height: 30),
            _submitButton(context),
          ],
        ),
      ),
    );
  }
}
