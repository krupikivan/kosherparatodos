import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/models/cliente.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/producto_notifier.dart';
import 'package:kosherparatodos/src/pages/user_pages/data/user_data_page.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/bloc/categoria_provider.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/pedido.dart';
import 'package:kosherparatodos/src/pages/user_pages/widgets/export.dart';
import 'package:kosherparatodos/src/providers/data_provider.dart';
import 'package:kosherparatodos/src/providers/notification_service.dart';
import 'package:kosherparatodos/src/providers/preferences.dart';
import 'package:kosherparatodos/style/theme.dart';
import 'package:provider/provider.dart';
import '../../providers/user_repository.dart';
import 'historial_pedidos/bloc/bloc.dart';
import 'historial_pedidos/export.dart';

class UserPage extends StatefulWidget {
  final FirebaseUser user;

  UserPage({Key key, this.user}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  static final Preferences _prefs = Preferences();

  TextStyle style;
  @override
  void initState() {
    super.initState();
    notificationService
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationService.setOnNotificationClick(onNotificationClick);
    if (_prefs.needData) {
      notificationService.showNotification(
          'Importante', 'Hay datos que necesitamos que complete', '');
    }
  }

  @override
  Widget build(BuildContext context) {
    blocUserData.getUserDataFromFirebase(widget.user.uid);
    style = TextStyle(color: Colors.black);
    final size = MediaQuery.of(context).size;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductoNotifier()),
        ChangeNotifierProvider(create: (context) => DataProvider.init()),
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
              "Kosher Cordoba",
              style: style,
            ),
            actions: <Widget>[
              IconCart(context: context),
            ],
          ),
          drawer: Builder(
            builder: (context) => StreamBuilder<Cliente>(
              stream: blocUserData.getCliente,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox();
                } else {
                  if (snapshot.data.direccion.calle == '' ||
                      snapshot.data.direccion.ciudad == '') {
                    _prefs.needData = true;
                  } else {
                    _prefs.needData = false;
                  }
                  return Drawer(
                    child:
                        ListView(padding: EdgeInsets.zero, children: <Widget>[
                      Container(
                        height: size.height * 0.25,
                        padding:
                            EdgeInsets.only(left: 30, top: size.height * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child:
                                  Image.asset('assets/icons/usuario_100.png'),
                              radius: 40,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Hola ${snapshot.data.nombre.nombre}',
                              style:
                                  TextStyle(fontSize: 25, color: Colors.white),
                            ),
                          ],
                        ),
                        decoration: new BoxDecoration(
                            color: Theme.of(context).primaryColor),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: _DrawerTile(
                          text: 'Historial de pedidos',
                          asset: 'assets/icons/carrito_100.png',
                        ),
                      ),
                      _DrawerTile(
                        text: 'Nuevo Pedido',
                        asset: 'assets/icons/categorias_100.png',
                      ),
                      _DrawerTile(
                        text: 'Datos',
                        asset: 'assets/icons/menu_100.png',
                      ),
                      Divider(color: Theme.of(context).dividerColor),
                      ListTile(
                          title: _DrawerText(text: 'Cerrar Sesion'),
                          leading: _DrawerImage(
                              image: 'assets/icons/salida_100.png'),
                          onTap: () => Provider.of<UserRepository>(context,
                                  listen: false)
                              .signOut()),
                    ]),
                  );
                }
              },
            ),
          ),
          body: StreamBuilder(
            stream: blocNav.getNavigation,
            initialData: blocNav.navigationProvider.currentNavigation,
            builder: (context, snapshot) {
              if (blocNav.navigationProvider.currentNavigation == "Historial") {
                blocUserData.getPedidos(widget.user.uid);
                return HistorialList();
              } else if (blocNav.navigationProvider.currentNavigation ==
                  "Nuevo Pedido") {
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

  void onNotificationInLowerVersions(
      ReceivedNotification receivedNotification) {}

  onNotificationClick(String payload) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        title: Text("Importante"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hay datos que necesitamos que complete',
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              "Completar",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              blocNav.updateNavigation('Datos');
            },
          ),
        ],
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
        blocNav.updateNavigation(text);
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
