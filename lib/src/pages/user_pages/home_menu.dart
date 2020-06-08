import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/user_widgets/user_widgets_export.dart';
import 'package:kosherparatodos/src/pages/user_pages/historial_pedidos/historial.dart';
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
    style = TextStyle(color: MyTheme.Colors.black);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: MyTheme.Colors.black),
        backgroundColor: MyTheme.Colors.white,
        title: Text(
          "Kosher para todos",
          style: style,
        ),
        actions: <Widget>[
          IconCart(context: context),
        ],
      ),
      drawer: Builder(
        builder: (context) => Drawer(
          child: ListView(padding: EdgeInsets.zero, children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: Icon(
                Icons.account_circle,
                size: 50,
                color: MyTheme.Colors.white,
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
            DrawerIconWidget(
                icon: Icons.history,
                text: 'Historial de pedidos',
                onTap: () {
                  Navigator.of(context).pop();
                  blocNav.updateNavigation('Historial');
                }),
            DrawerIconWidget(
                icon: Icons.fastfood,
                text: 'Productos',
                onTap: () {
                  Navigator.of(context).pop();
                  blocNav.updateNavigation('Productos');
                }),
            DrawerIconWidget(
                icon: Icons.exit_to_app,
                text: 'Cerrar Sesion',
                onTap: () => Provider.of<UserRepository>(context, listen: false)
                    .signOut()),
          ]),
        ),
      ),
      body: StreamBuilder(
        stream: blocNav.getNavigation,
        initialData: blocNav.navigationProvider.currentNavigation,
        builder: (context, snapshot) {
          if (blocNav.navigationProvider.currentNavigation == "Historial") {
            blocUserData.getPedidos(user.uid);
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
}
