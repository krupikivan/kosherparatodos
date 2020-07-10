import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  SubmitButton({Key key, this.text, this.action}) : super(key: key);
  final String text;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: action,
      color: Colors.white,
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
      ),
      minWidth: MediaQuery.of(context).size.width,
      height: 50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
    );
  }
}
