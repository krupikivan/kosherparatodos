import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/popup_menu.dart';
import 'package:kosherparatodos/src/pages/home_pages/bloc/user_data_bloc.dart';
import 'package:kosherparatodos/src/pages/home_pages/history_page.dart';
import 'package:kosherparatodos/src/pages/home_pages/product_list_page.dart';
import 'package:kosherparatodos/src/utils/item.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class UserPage extends StatefulWidget {
  final FirebaseUser user;

  const UserPage({Key key, this.user}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  int _currentIndex = 0;
  final List<Widget> _children = [
    HistoryPage(),
    ProductListPage(),
  ];

  TextStyle style;
  List<Item> choices;

  @override
  void initState(){
    blocUserData.getUserDataFromFirebase(widget.user.uid);
    style = TextStyle(color: MyTheme.Colors.light);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _fillPopupData();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyTheme.Colors.dark,
        title: ListTile(title: Text("Kosher para todos", style: style,), subtitle: Text(widget.user.email, style: style,), leading: Icon(Icons.account_circle, color: MyTheme.Colors.light,),),
        actions: <Widget>[
          PopupMenu(choices: choices),
        ],
      ),
      body: _children[_currentIndex],
      //Bottom Navigation ----------------------------------------
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: MyTheme.Colors.dark,
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.history),
            title: new Text('Historial'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.fastfood),
            title: new Text('Productos'),
          )
        ],
      ),
      //Bottom Navigation ----------------------------------------
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
          Text('Nuevo pedido',
              style: TextStyle(fontFamily: MyTheme.Fonts.primaryFont)),
          Icon(Icons.add)),
    Item(
          Text('Cerrar Sesion',
              style: TextStyle(fontFamily: MyTheme.Fonts.primaryFont)),
          Icon(Icons.account_circle)),
    ];
  }
}
