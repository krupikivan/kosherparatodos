import 'package:flutter/material.dart';

class CustomIcon extends StatelessWidget {
  const CustomIcon({Key key, this.icon, this.context}) : super(key: key);
  final IconData icon;
  final BuildContext context;
  @override
  Widget build(context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(40)),
          border: Border.all(
              color: Theme.of(context).primaryColor, style: BorderStyle.solid)),
      child: Icon(icon, size: 35, color: Colors.white),
    );
  }
}
