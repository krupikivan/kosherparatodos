import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/pages/admin_pages/navigation_bloc.dart';
import 'package:kosherparatodos/src/pages/admin_pages/pedidos/export.dart';
import 'package:kosherparatodos/src/pages/admin_pages/productos/producto_list_page.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/categoria_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/cliente_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/pedido_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';
import 'package:kosherparatodos/src/providers/user_repository.dart';
import 'package:kosherparatodos/style/theme.dart';
import 'package:provider/provider.dart';

import 'clientes/export.dart';

class AdminPage extends StatelessWidget {
  final FirebaseUser user;
  AdminPage({Key key, this.user}) : super(key: key);
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Admin Main");

  final TextStyle style = TextStyle(color: Colors.black);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ClienteNotifier.init()),
        ChangeNotifierProvider(create: (context) => PedidoNotifier.init()),
        ChangeNotifierProvider(create: (context) => ProductoNotifier()),
        ChangeNotifierProvider(create: (context) => CategoriaNotifier.init()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeData(),
        home: Scaffold(
          appBar: AppBar(
            title: StreamBuilder(
                stream: bloc.getNavigation,
                initialData: bloc.navigationProvider.currentNavigation,
                builder: (context, snapshot) {
                  return Text(
                    _getTitle(bloc.navigationProvider.currentNavigation),
                    style: style,
                  );
                }),
          ),
          drawerScrimColor: Theme.of(context).hoverColor,
          drawer: SizedBox(
            width: MediaQuery.of(context).size.width / 1.5,
            child: Builder(
              builder: (context) => SafeArea(
                child: Drawer(
                  child: ListView(padding: EdgeInsets.zero, children: <Widget>[
                    Container(
                      height: size.height * 0.25,
                      padding:
                          EdgeInsets.only(left: 30, top: size.height * 0.05),
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
                            'Administrador',
                            style: TextStyle(fontSize: 25, color: Colors.white),
                          ),
                          Text(
                            user.email,
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                      decoration: new BoxDecoration(
                          color: Theme.of(context).primaryColor),
                    ),
                    ListTile(
                      title: Text('Clientes'),
                      leading: Icon(
                        Icons.people,
                        color: Theme.of(context).primaryColor,
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
                        color: Theme.of(context).primaryColor,
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
                        color: Theme.of(context).primaryColor,
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        bloc.updateNavigation('Productos');
                      },
                    ),
                    Divider(color: Theme.of(context).dividerColor),
                    ListTile(
                        title: Text('Cerrar Sesion'),
                        leading: Icon(
                          Icons.exit_to_app,
                          color: Theme.of(context).primaryColor,
                        ),
                        onTap: () =>
                            Provider.of<UserRepository>(context, listen: false)
                                .signOut()),
                  ]),
                ),
              ),
            ),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
            ),
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
                  return ProductoListPage();
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
    return 'Kosher en un click';
  }
}
