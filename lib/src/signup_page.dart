import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/title_widget.dart';
import 'package:kosherparatodos/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

import 'Widget/login_button.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  TextStyle style = TextStyle(color: MyTheme.Colors.light, fontFamily: MyTheme.Fonts.primaryFont, fontSize: 20.0);
  TextEditingController _name;
  TextEditingController _email;
  TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: "");
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Provider.of<UserRepository>(context, listen: false).goWelcome();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child:
                  Icon(Icons.keyboard_arrow_left, color: MyTheme.Colors.light),
            ),
            Text('Volver',
                style: TextStyle(
                    color: MyTheme.Colors.light,
                    fontSize: 12,
                    fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, controller, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                color: MyTheme.Colors.light,
                fontWeight: FontWeight.bold,
                fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
              validator: (value) => (value.isEmpty) ? "Ingrese datos" : null,
              controller: controller,
              style: style,
              cursorColor: MyTheme.Colors.light,
              obscureText: isPassword,
              decoration: InputDecoration(
              errorStyle: TextStyle(color: MyTheme.Colors.light),
              labelStyle: TextStyle(color: MyTheme.Colors.light),
                 focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: MyTheme.Colors.light)),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyTheme.Colors.light)),
                errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyTheme.Colors.light)),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: MyTheme.Colors.light)),
              ))
        ],
      ),
    );
  }

  Widget _submitButton(UserRepository user) {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          await user
              .signup(_name.text, _email.text, _password.text)
              .then((onValue) {
             user.signOutOnRegister();
            _key.currentState.showSnackBar(SnackBar(
              content: Text("Usuario creado, espere confirmacion."),
            ));
          }).catchError((e) {
            _key.currentState.showSnackBar(SnackBar(
              content: Text("Error!"),
            ));
          });
        }
      },
      child: LoginButton(
        name: 'Registrate',
      ),
    );
  }

  Widget _loginAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Ya tienes cuenta?',
            style: TextStyle(
                color: MyTheme.Colors.light,
                fontSize: 13,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              Provider.of<UserRepository>(context, listen: false).goLogin();
            },
            child: Text(
              'Ingresar',
              style: TextStyle(
                  color: MyTheme.Colors.light,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Widget _emailPasswordWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _entryField("Nombre", _name),
          _entryField("Email", _email),
          _entryField("Contraseña", _password, isPassword: true),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Scaffold(
        key: _key,
        body: SingleChildScrollView(
            child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: SizedBox(),
                    ),
                    TitleLabel(),
                    SizedBox(
                      height: 20,
                    ),
                    _emailPasswordWidget(),
                    SizedBox(
                      height: 20,
                    ),
                    user.status == Status.Registering
                        ? Center(child: CircularProgressIndicator())
                        : _submitButton(user),
                    Expanded(
                      flex: 2,
                      child: SizedBox(),
                    )
                  ],
                ),
                decoration: BoxDecoration(color: MyTheme.Colors.dark),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: _loginAccountLabel(),
              ),
              Positioned(top: 40, left: 0, child: _backButton()),
            ],
          ),
        )));
  }
}
