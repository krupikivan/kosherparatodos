import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/export.dart';
import 'package:kosherparatodos/src/models/cliente.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/categoria_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/bloc/categoria_provider.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/pedido.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;
import 'package:provider/provider.dart';
import '../../providers/user_repository.dart';
import 'historial_pedidos/bloc/bloc.dart';
import 'historial_pedidos/export.dart';

class UserPage extends StatelessWidget {
  final FirebaseUser user;
  TextStyle style;

  UserPage({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    blocUserData.getUserDataFromFirebase(user.uid);
    style = TextStyle(color: MyTheme.Colors.black);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductoNotifier()),
        ChangeNotifierProvider(create: (context) => CategoriaProvider.init()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
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
            builder: (context) => StreamBuilder<Cliente>(
              stream: blocUserData.getCliente,
              builder: (context, snapshot) => !snapshot.hasData
                  ? SizedBox()
                  : Drawer(
                      child:
                          ListView(padding: EdgeInsets.zero, children: <Widget>[
                        UserAccountsDrawerHeader(
                          currentAccountPicture: Icon(
                            Icons.account_circle,
                            size: 50,
                            color: MyTheme.Colors.primary,
                          ),
                          accountName: Text(
                            'Hola!',
                            style: TextStyle(
                                fontSize: 25, color: MyTheme.Colors.primary),
                          ),
                          accountEmail: Text(
                            '${snapshot.data.nombre.nombre} ${snapshot.data.nombre.apellido}',
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: MyTheme.Colors.primary),
                          ),
                          decoration:
                              new BoxDecoration(color: MyTheme.Colors.white),
                        ),
                        ListTile(
                          title: Text('Historial de pedidos'),
                          leading: Icon(
                            Icons.history,
                            color: MyTheme.Colors.primary,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            blocNav.updateNavigation('Historial');
                          },
                        ),
                        ListTile(
                          title: Text('Productos'),
                          leading: Icon(
                            Icons.fastfood,
                            color: MyTheme.Colors.primary,
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                            blocNav.updateNavigation('Productos');
                          },
                        ),
                        ListTile(
                          title: Text('Cerrar Sesion'),
                          leading: Icon(
                            Icons.exit_to_app,
                            color: MyTheme.Colors.primary,
                          ),
                          onTap: () => Provider.of<UserRepository>(context,
                                  listen: false)
                              .signOut(),
                        ),
                      ]),
                    ),
            ),
          ),
          body: StreamBuilder(
            stream: blocNav.getNavigation,
            initialData: blocNav.navigationProvider.currentNavigation,
            builder: (context, snapshot) {
              if (blocNav.navigationProvider.currentNavigation == "Historial") {
                blocUserData.getPedidos(user.uid);
                return UserPedidoListPage();
              }
              if (blocNav.navigationProvider.currentNavigation == "Productos") {
                return ProductoGridPage();
              }
              return UserPedidoListPage();
            },
          ),
        ),
      ),
    );
  }
}
