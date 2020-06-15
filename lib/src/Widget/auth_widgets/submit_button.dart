import 'package:flutter/material.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class SubmitButton extends StatelessWidget {
  SubmitButton({Key key, this.text, this.action}) : super(key: key);
  final String text;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: action,
      color: MyTheme.Colors.white,
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: MyTheme.Colors.primary),
      ),
      minWidth: MediaQuery.of(context).size.width,
      height: 50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    );
  }
}
