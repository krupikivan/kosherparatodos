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
import 'package:kosherparatodos/src/pages/admin_pages/categorias/categoria_page.dart';
import 'package:kosherparatodos/src/providers/data_provider.dart';
import 'package:kosherparatodos/src/providers/user_repository.dart';
import 'package:kosherparatodos/style/theme.dart';
import 'package:provider/provider.dart';

import 'clientes/export.dart';

class AdminPage extends StatelessWidget {
  final FirebaseUser user;
  AdminPage({Key key, this.user}) : super(key: key);
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Admin Main");

  @override
  Widget build(BuildContext context) {
    final TextStyle style = TextStyle(color: Theme.of(context).primaryColor, fontSize: 25, fontWeight: FontWeight.w500);
    final size = MediaQuery.of(context).size;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ClienteNotifier.init()),
        ChangeNotifierProvider(create: (context) => PedidoNotifier.init()),
        ChangeNotifierProvider(create: (context) => ProductoNotifier()),
        ChangeNotifierProvider(create: (context) => CategoriaNotifier.init()),
        ChangeNotifierProvider(create: (context) => DataProvider.init()),
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
                      padding: EdgeInsets.only(
                          left: 30, right: 30, top: size.height * 0.05),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Image.asset('assets/icons/admin_100.png'),
                            radius: 40,
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
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: _DrawerTile(
                        text: 'Clientes',
                        asset: 'assets/icons/clientes_100.png',
                      ),
                    ),
                    _DrawerTile(
                      text: 'Pedidos',
                      asset: 'assets/icons/carrito_100.png',
                    ),
                    _DrawerTile(
                      text: 'Productos',
                      asset: 'assets/icons/codigo_barras_100.png',
                    ),
                    _DrawerTile(
                      text: 'Categorias',
                      asset: 'assets/icons/categorias_100.png',
                    ),
                    Divider(color: Theme.of(context).dividerColor),
                    ListTile(
                        title: _DrawerText(text: 'Cerrar Sesion'),
                        leading:
                            _DrawerImage(image: 'assets/icons/salida_100.png'),
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
                if (bloc.navigationProvider.currentNavigation == "Categorias") {
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

class _DrawerTile extends StatelessWidget {
  final String text;
  final String asset;

  const _DrawerTile({
    Key key,
    this.text,
    this.asset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _DrawerText(text: text),
      leading: _DrawerImage(image: asset),
      onTap: () {
        Navigator.of(context).pop();
        bloc.updateNavigation(text);
      },
    );
  }
}

class _DrawerImage extends StatelessWidget {
  final String image;
  const _DrawerImage({
    Key key,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      height: 35,
      alignment: Alignment.center,
    );
  }
}

class _DrawerText extends StatelessWidget {
  final String text;
  const _DrawerText({
    Key key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: 20),
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
  } else if (bloc.navigationProvider.currentNavigation == "Categorias") {
    return 'Categorias';
  } else {
    return 'Kosher Cordoba';
  }
}
