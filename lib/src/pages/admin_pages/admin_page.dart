import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/popup_menu.dart';
import 'package:kosherparatodos/src/pages/admin_pages/cliente_page.dart';
import 'package:kosherparatodos/src/pages/admin_pages/pedidos_page.dart';
import 'package:kosherparatodos/src/pages/admin_pages/provider/cliente_notifier.dart';
import 'package:kosherparatodos/src/utils/item.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;
import 'package:provider/provider.dart';

class AdminPage extends StatefulWidget {
  final FirebaseUser user;

  const AdminPage({Key key, this.user}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    ClientePage(),
    PedidosPage(),
  ];

  TextStyle style;
  List<Item> choices;

  @override
  void initState(){
    style = TextStyle(color: MyTheme.Colors.light);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _fillPopupData();
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ClienteNotifier.instance()),
        ],
          child: MaterialApp(

                      home: Scaffold(
        appBar: AppBar(
            backgroundColor: MyTheme.Colors.dark,
            title: Text("Kosher para todos", style: style,),
            actions: <Widget>[
              PopupMenu(choices: choices),
            ],
        ),
        body: _children[_currentIndex],
        //Bottom Navigation ----------------------------------------
        bottomNavigationBar: BottomNavigationBar(
            selectedItemColor: MyTheme.Colors.primary,
            onTap: onTabTapped, // new
            currentIndex: _currentIndex, // this will be set when a new tab is tapped
            items: [
              BottomNavigationBarItem(
                icon: new Icon(Icons.history),
                title: new Text('Clientes'),
              ),
              BottomNavigationBarItem(
                icon: new Icon(Icons.fastfood),
                title: new Text('Pedidos'),
              )
            ],
        ),
        //Bottom Navigation ----------------------------------------
      ),
          ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  ///PUPUP menu
  _fillPopupData() {
    choices = <Item>[
    Item(
          Text('Cerrar Sesion',
              style: TextStyle(fontFamily: MyTheme.Fonts.primaryFont)),
          Icon(Icons.account_circle)),
    ];
  }
}
