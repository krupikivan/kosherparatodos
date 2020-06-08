import 'package:flutter/material.dart';

class DrawerIconWidget extends StatelessWidget {
  const DrawerIconWidget({Key key, this.icon, this.text, this.onTap})
      : super(key: key);
  final IconData icon;
  final String text;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
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
}
