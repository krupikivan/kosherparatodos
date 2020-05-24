import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/pages/user_pages/historial_pedidos/historial.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/bloc/bloc.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/pedido.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;
import 'package:provider/provider.dart';
import '../../../user_repository.dart';
import 'historial_pedidos/bloc/bloc.dart';
import 'package:kosherparatodos/src/Widget/drawer_icon_widget.dart';

class UserPage extends StatelessWidget {
  final FirebaseUser user;
  TextStyle style;

  UserPage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    blocUserData.getUserDataFromFirebase(user.uid);
    style = TextStyle(color: MyTheme.Colors.light);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.Colors.dark,
        title: Text("Kosher para todos", style: style,),
        actions: <Widget>[
          _iconCartPage(context),
        ],
      ),
          drawer: Builder(
            builder: (context) => Drawer(
              child: ListView(padding: EdgeInsets.zero, children: <Widget>[
                UserAccountsDrawerHeader(
                  currentAccountPicture: Icon(
                    Icons.account_circle,
                    size: 50,
                    color: MyTheme.Colors.light,
                  ),
                  accountName: Text(
                    'Bienvenido',
                    style: TextStyle(fontSize: 25),
                  ),
                  accountEmail: Text(
                    user.email,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  decoration: new BoxDecoration(
                      image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new AssetImage('assets/back-drawer.jpg'))),
                ),
                // _createHeader(),
                DrawerIconWidget(
                    icon: Icons.history,
                    text: 'Historial de pedidos',
                    onTap: () {
                      Navigator.of(context).pop();
                      blocNav.updateNavigation('Historial');
                    }),
                DrawerIconWidget(
                    icon: Icons.fastfood,
                    text: 'Pedidos',
                    onTap: () {
                      Navigator.of(context).pop();
                      blocNav.updateNavigation('Productos');
                    }),
                DrawerIconWidget(
                    icon: Icons.exit_to_app,
                    text: 'Cerrar Sesion',
                    onTap: () =>
                              Provider.of<UserRepository>(context, listen: false).signOut()),
              ]),
            ),
          ),
                    body: StreamBuilder(
            stream: blocNav.getNavigation,
            initialData: blocNav.navigationProvider.currentNavigation,
            builder: (context, snapshot) {
              if (blocNav.navigationProvider.currentNavigation == "Historial") {
                return HistorialListadoPedidoPage();
              }
              if (blocNav.navigationProvider.currentNavigation == "Productos") {
                return ProductoGridPage();
              }
              return HistorialListadoPedidoPage();
            },
          ),
    );
  }

Widget _iconCartPage(context){
  return new Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Container(
                  height: 150.0,
                  width: 30.0,
                  child: new GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          new MaterialPageRoute(
                              builder:(BuildContext context) =>
                              new DetallePedidoListPage()
                          )
                      );
                    },
                    child: new Stack(
                      children: <Widget>[
                        new IconButton(
                          icon: new Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                          onPressed: null,
                        ),
                        new Positioned(
                            child: new Stack(
                          children: <Widget>[
                            new Icon(Icons.brightness_1,
                                size: 20.0, color: Colors.green[800]),
                            new Positioned(
                                top: 3.0,
                                right: 4.0,
                                child: new Center(
                                  child: StreamBuilder<Pedido>(
                                      stream: blocPedidoVigente.getPedido,
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData || snapshot.data.productos == null)
                                          return Text('0');
                                        else
                                          return new Text(
                                            snapshot.data
                                            .productos
                                                .length.toString(),
                                            style: new TextStyle(
                                                color: Colors.white,
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.w500),
                                          );
                                      }),
                                )),
                          ],
                        )),
                      ],
                    ),
                  )));
}
}