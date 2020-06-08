import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/title_widget.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;
import 'package:kosherparatodos/user_repository.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Widget _submitButton() {
    return MaterialButton(
      onPressed: () {
        Provider.of<UserRepository>(context, listen: false).goLogin();
      },
      color: MyTheme.Colors.secondary,
      child: Text(
        'INGRESAR',
        style: TextStyle(fontSize: 20),
      ),
      minWidth: MediaQuery.of(context).size.width,
      height: 60,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }

  Widget _signUpButton() {
    return MaterialButton(
      onPressed: () {
        Provider.of<UserRepository>(context, listen: false).goSignup();
      },
      color: MyTheme.Colors.accent,
      child: Text(
        'REGISTRARSE',
        style: TextStyle(fontSize: 20),
      ),
      minWidth: MediaQuery.of(context).size.width,
      height: 60,
      textColor: MyTheme.Colors.secondary,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(width: 2, color: MyTheme.Colors.secondary)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
                colors: [MyTheme.Colors.accent, MyTheme.Colors.primary],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.15, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              SizedBox(
                height: 1,
              ),
              TitleLabel(),
              Column(
                children: <Widget>[
                  _submitButton(),
                  SizedBox(
                    height: 30,
                  ),
                  _signUpButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
