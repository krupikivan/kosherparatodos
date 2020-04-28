import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/popup_menu.dart';
import 'package:kosherparatodos/src/models/pedido.dart';
import 'package:kosherparatodos/src/pages/user_pages/historial_pedidos/historial.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/bloc/bloc.dart';
import 'package:kosherparatodos/src/pages/user_pages/pedido/pedido.dart';
import 'package:kosherparatodos/src/utils/item.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;
import 'historial_pedidos/bloc/bloc.dart';

class UserPage extends StatefulWidget {
  final FirebaseUser user;

  const UserPage({Key key, this.user}) : super(key: key);

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {

  int _currentIndex = 0;
  
  final List<Widget> _children = [
    HistorialListadoPedidoPage(),
    ProductoGridPage(),
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
        title: Text("Kosher para todos", style: style,),
        actions: <Widget>[
          _iconCartPage(),
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

Widget _iconCartPage(){
  return new Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Container(
                  height: 150.0,
                  width: 30.0,
                  child: new GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          new MaterialPageRoute(
                              builder:(BuildContext context) =>
                              new DetallePedidoListPage()
                          )
                      );
                    },
                    child: new Stack(
                      children: <Widget>[
                        new IconButton(
                          icon: new Icon(
                            Icons.shopping_cart,
                            color: Colors.white,
                          ),
                          onPressed: null,
                        ),
                        new Positioned(
                            child: new Stack(
                          children: <Widget>[
                            new Icon(Icons.brightness_1,
                                size: 20.0, color: Colors.green[800]),
                            new Positioned(
                                top: 3.0,
                                right: 4.0,
                                child: new Center(
                                  child: StreamBuilder<Pedido>(
                                      stream: blocPedidoVigente.getPedido,
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData || snapshot.data.detallePedido == null)
                                          return Text('0');
                                        else
                                          return new Text(
                                            snapshot.data
                                            .detallePedido
                                                .length.toString(),
                                            style: new TextStyle(
                                                color: Colors.white,
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.w500),
                                          );
                                      }),
                                )),
                          ],
                        )),
                      ],
                    ),
                  )));
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
