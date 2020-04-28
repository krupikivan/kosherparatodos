import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/pages/admin_pages/cliente_page.dart';
import 'package:kosherparatodos/src/pages/admin_pages/navigation_bloc.dart';
import 'package:kosherparatodos/src/pages/admin_pages/pedidos_page.dart';
import 'package:kosherparatodos/src/pages/admin_pages/productos.page.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/cliente_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/pedido_notifier.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;
import 'package:kosherparatodos/user_repository.dart';
import 'package:provider/provider.dart';

class AdminPage extends StatelessWidget {
  final FirebaseUser user;
  AdminPage({Key key, this.user}) : super(key: key);
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Admin Main");

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ClienteNotifier.init()),
        ChangeNotifierProvider(create: (context) => PedidoNotifier.init()),
        ChangeNotifierProvider(create: (context) => ProductoNotifier.init()),
      ],
      child: MaterialApp(
        // initialRoute: '/',
        // routes: {
        //   '/clientes': (BuildContext context) => ClientePage(),
        // },
        // onGenerateRoute: RouteGenerator.generateRoute,
        // key: navigatorKey,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          // key: _skey,
          appBar: AppBar(
            backgroundColor: MyTheme.Colors.dark,
            title: StreamBuilder(
                stream: bloc.getNavigation,
                initialData: bloc.navigationProvider.currentNavigation,
                builder: (context, snapshot) {
                  return Text(
                    _getTitle(bloc.navigationProvider.currentNavigation),
                    style: TextStyle(color: MyTheme.Colors.light),
                  );
                }),
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
                    'Administrador',
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
                _createDrawerItem(
                    icon: Icons.contacts,
                    text: 'Clientes',
                    onTap: () {
                      Navigator.of(context).pop();
                      bloc.updateNavigation('Clientes');
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (BuildContext context) => ClientePage()));
                    }),
                _createDrawerItem(
                    icon: Icons.view_list,
                    text: 'Pedidos',
                    onTap: () {
                      Navigator.of(context).pop();
                      bloc.updateNavigation('Pedidos');
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (BuildContext context) => PedidosPage()));
                    }),
                _createDrawerItem(
                    icon: Icons.shopping_basket,
                    text: 'Administrar productos',
                    onTap: () {
                      Navigator.of(context).pop();
                      bloc.updateNavigation('Productos');
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (BuildContext context) => PedidosPage()));
                    }),
                _createDrawerItem(
                    icon: Icons.exit_to_app,
                    text: 'Cerrar Sesion',
                    onTap: () =>
                        Provider.of<UserRepository>(context, listen: false)
                            .signOut()),
              ]),
            ),
          ),
          body: StreamBuilder(
            stream: bloc.getNavigation,
            initialData: bloc.navigationProvider.currentNavigation,
            builder: (context, snapshot) {
              if (bloc.navigationProvider.currentNavigation == "Clientes") {
                return ClientePage();
              }
              if (bloc.navigationProvider.currentNavigation == "Pedidos") {
                return PedidosPage();
              }
              if (bloc.navigationProvider.currentNavigation == "Productos") {
                return ProductosPage();
              }
              return ClientePage();
            },
          ),
        ),
      ),
    );
  }
}

_getTitle(title) {
  if (bloc.navigationProvider.currentNavigation == "Clientes") {
    return 'Clientes';
  }
  else if (bloc.navigationProvider.currentNavigation == "Pedidos") {
    return 'Pedidos';
  }
  else if (bloc.navigationProvider.currentNavigation == "Productos") {
    return 'Productos';
  }
  else{
    return 'Kosher Para Todos';
  }
}

Widget _createDrawerItem(
    {IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}
