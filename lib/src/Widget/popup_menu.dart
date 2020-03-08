import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/utils/item.dart';
import 'package:kosherparatodos/user_repository.dart';
import 'package:provider/provider.dart';

class PopupMenu extends StatefulWidget {

  final List<Item> choices;
  final String type;
  PopupMenu({Key key, this.choices, this.type}) : super(key: key);

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
      Provider.of<UserRepository>(context, listen: false).signOut();
    }
  }

}
