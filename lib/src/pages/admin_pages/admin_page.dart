import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kosherparatodos/src/pages/admin_pages/navigation_bloc.dart';
import 'package:kosherparatodos/src/pages/admin_pages/pedidos/export.dart';
import 'package:kosherparatodos/src/pages/admin_pages/productos/categoria_page.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/categoria_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/cliente_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/pedido_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;
import 'package:kosherparatodos/src/providers/user_repository.dart';
import 'package:provider/provider.dart';

import 'clientes/export.dart';

class AdminPage extends StatelessWidget {
  final FirebaseUser user;
  AdminPage({Key key, this.user}) : super(key: key);
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Admin Main");

  final TextStyle style = TextStyle(color: MyTheme.Colors.black);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ClienteNotifier.init()),
        ChangeNotifierProvider(create: (context) => PedidoNotifier.init()),
        ChangeNotifierProvider(create: (context) => ProductoNotifier()),
        ChangeNotifierProvider(create: (context) => CategoriaNotifier.init()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: GoogleFonts.muli().fontFamily,
          appBarTheme: AppBarTheme(
            textTheme: TextTheme(
                headline6: TextStyle(
              fontFamily: GoogleFonts.muli().fontFamily,
              fontSize: 20,
            )),
            brightness: Brightness.light,
            color: Colors.grey.shade50,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
          ),
        ),
        home: Scaffold(
          appBar: AppBar(
            title: StreamBuilder(
                stream: bloc.getNavigation,
                initialData: bloc.navigationProvider.currentNavigation,
                builder: (context, snapshot) {
                  return Text(
                    _getTitle(bloc.navigationProvider.currentNavigation),
                    style: MyTheme.Colors.headerStyle,
                  );
                }),
          ),
          drawerScrimColor: Colors.black54,
          drawer: SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            child: Builder(
              builder: (context) => Drawer(
                child: ListView(padding: EdgeInsets.zero, children: <Widget>[
                  UserAccountsDrawerHeader(
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: MyTheme.Colors.white,
                      foregroundColor: MyTheme.Colors.black,
                      child: Icon(
                        Icons.person,
                        size: 70,
                        color: MyTheme.Colors.darkGrey,
                      ),
                    ),
                    accountName: Text(
                      'Administrador',
                      style: TextStyle(
                          color: MyTheme.Colors.darkGrey, fontSize: 23),
                    ),
                    accountEmail: Text(
                      user.email,
                      style: TextStyle(
                          fontSize: 17, color: MyTheme.Colors.darkGrey),
                    ),
                    decoration: BoxDecoration(color: MyTheme.Colors.white),
                  ),
                  ListTile(
                    title: Text('Clientes'),
                    leading: Icon(
                      Icons.people,
                      color: MyTheme.Colors.primary,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      bloc.updateNavigation('Clientes');
                    },
                  ),
                  ListTile(
                    title: Text('Pedidos'),
                    leading: Icon(
                      Icons.shopping_basket,
                      color: MyTheme.Colors.primary,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      bloc.updateNavigation('Pedidos');
                    },
                  ),
                  ListTile(
                    title: Text('Categorias / Productos'),
                    leading: Icon(
                      Icons.list,
                      color: MyTheme.Colors.primary,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      bloc.updateNavigation('Productos');
                    },
                  ),
                  Divider(color: MyTheme.Colors.darkGrey),
                  ListTile(
                      title: Text('Cerrar Sesion'),
                      leading: Icon(
                        Icons.exit_to_app,
                        color: MyTheme.Colors.primary,
                      ),
                      onTap: () =>
                          Provider.of<UserRepository>(context, listen: false)
                              .signOut()),
                ]),
              ),
            ),
          ),
          body: Container(
            color: Colors.grey.shade50,
            child: StreamBuilder(
              stream: bloc.getNavigation,
              initialData: bloc.navigationProvider.currentNavigation,
              builder: (context, snapshot) {
                if (bloc.navigationProvider.currentNavigation == "Clientes") {
                  return ClienteListPage();
                }
                if (bloc.navigationProvider.currentNavigation == "Pedidos") {
                  return PedidosListPage();
                }
                if (bloc.navigationProvider.currentNavigation == "Productos") {
                  return CategoriaPage();
                }
                return ClienteListPage();
              },
            ),
          ),
        ),
      ),
    );
  }
}

String _getTitle(title) {
  if (bloc.navigationProvider.currentNavigation == "Clientes") {
    return 'Clientes';
  } else if (bloc.navigationProvider.currentNavigation == "Pedidos") {
    return 'Pedidos';
  } else if (bloc.navigationProvider.currentNavigation == "Productos") {
    return 'Productos';
  } else {
    return 'Kosher Para Todos';
  }
}
