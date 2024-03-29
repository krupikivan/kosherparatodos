import 'package:flutter/material.dart';

class Labeltext extends StatelessWidget {
  const Labeltext({Key key, this.label, this.action}) : super(key: key);
  final String label;

  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Align(
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }
}
