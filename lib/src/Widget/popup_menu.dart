import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/pages/home_pages/bloc/product_data_bloc.dart';
import 'package:kosherparatodos/src/pages/home_pages/new_pedido_page.dart';
import 'package:kosherparatodos/src/utils/item.dart';
import 'package:kosherparatodos/user_repository.dart';
import 'package:provider/provider.dart';

class PopupMenu extends StatefulWidget {

  final List<Item> choices;
  PopupMenu({Key key, this.choices}) : super(key: key);

  @override
  _PopupMenuState createState() => _PopupMenuState();
}

class _PopupMenuState extends State<PopupMenu> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<Item>(
      onSelected: choiceActionMenu,
      itemBuilder: (BuildContext context) {
        return widget.choices.map((Item choice) {
          return PopupMenuItem<Item>(
              value: choice,
              child: ListTile(
                leading: choice.icon,
                title: choice.title,
              )
          );
        }).toList();
      },
    );
  }

  void choiceActionMenu(Item choice) {
    if (choice.title.data == widget.choices[0].title.data) {
        blocProductData.getProductList();
          Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewPedidoPage()));
    }
    else{
      Provider.of<UserRepository>(context, listen: false).signOut();
    }
  }

}
