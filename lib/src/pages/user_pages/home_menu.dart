import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/models/cliente.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';
import 'package:kosherparatodos/src/pages/user_pages/data/user_data_page.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/bloc/categoria_provider.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/pedido.dart';
import 'package:kosherparatodos/src/pages/user_pages/widgets/export.dart';
import 'package:kosherparatodos/style/theme.dart';
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
    style = TextStyle(color: Colors.black);
    final size = MediaQuery.of(context).size;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductoNotifier()),
        ChangeNotifierProvider(create: (context) => CategoriaProvider.init()),
      ],
      child: MaterialApp(
        theme: themeData(),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          appBar: AppBar(
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
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
                  : SafeArea(
                      child: Drawer(
                        child: ListView(
                            padding: EdgeInsets.zero,
                            children: <Widget>[
                              Container(
                                height: size.height * 0.25,
                                padding: EdgeInsets.only(
                                    left: 30, top: size.height * 0.05),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Icon(
                                      Icons.account_circle,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'Hola ${snapshot.data.nombre.nombre}',
                                      style: TextStyle(
                                          fontSize: 25, color: Colors.white),
                                    ),
                                  ],
                                ),
                                decoration: new BoxDecoration(
                                    color: Theme.of(context).primaryColor),
                              ),
                              ListTile(
                                title: Text('Historial de pedidos'),
                                leading: Icon(
                                  Icons.history,
                                  color: Theme.of(context).primaryColor,
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
                                  color: Theme.of(context).primaryColor,
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  blocNav.updateNavigation('Productos');
                                },
                              ),
                              ListTile(
                                title: Text('Datos'),
                                leading: Icon(
                                  Icons.info_outline,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                  blocNav.updateNavigation('Datos');
                                },
                              ),
                              ListTile(
                                title: Text('Cerrar Sesion'),
                                leading: Icon(
                                  Icons.exit_to_app,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onTap: () => Provider.of<UserRepository>(
                                        context,
                                        listen: false)
                                    .signOut(),
                              ),
                            ]),
                      ),
                    ),
            ),
          ),
          body: StreamBuilder(
            stream: blocNav.getNavigation,
            initialData: blocNav.navigationProvider.currentNavigation,
            builder: (context, snapshot) {
              if (blocNav.navigationProvider.currentNavigation == "Historial") {
                blocUserData.getPedidos(user.uid);
                return HistorialList();
              } else if (blocNav.navigationProvider.currentNavigation ==
                  "Productos") {
                return ProductoGridPage();
              } else if (blocNav.navigationProvider.currentNavigation ==
                  "Datos") {
                return UserDataPage();
              }
              return HistorialList();
            },
          ),
        ),
      ),
    );
  }
}
