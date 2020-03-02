import 'package:flutter/material.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class LoginButton extends StatelessWidget {
  const LoginButton({Key key, this.name}) : super(key: key);
  final name;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xffdf8e33).withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.white),
        child: Text(
          name,
          style: TextStyle(fontSize: 20, color: MyTheme.Colors.dark),
        ),
      );
  }
}