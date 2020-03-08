import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kosherparatodos/src/repository/repo.dart';
import 'package:kosherparatodos/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

import 'Widget/login_button.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email;
  TextEditingController _password;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  TextStyle style = TextStyle(
      color: MyTheme.Colors.light,
      fontFamily: MyTheme.Fonts.primaryFont,
      fontSize: 20.0);

  @override
  void initState() {
    super.initState();
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

  Widget _submitButton(user) {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          await _signIn(user);
        }
      },
      child: LoginButton(
        name: 'Ingresar',
      ),
    );
  }

  _signIn(UserRepository user) async {
    try {
      await repo.isAuthenticated(_email.text).then((data) async {
        if (data.documents.length == 0 ||
            data.documents[0].data['isAuthenticated'] == true) {
          if (!await user.signIn(_email.text, _password.text)) {
            throw 'Ingreso incorrecto.';
          }
        } else {
          throw 'Expere confirmacion por mail.';
        }
      });
    } catch (e) {
      _key.currentState.showSnackBar(SnackBar(
        content: Text(e),
      ));
    }
  }

  Widget _createAccountLabel() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'No tienes cuenta?',
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
              Provider.of<UserRepository>(context, listen: false).goSignup();
            },
            child: Text(
              'Registrate',
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

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: 'Kosher Para Todos',
        style: GoogleFonts.portLligatSans(
          textStyle: Theme.of(context).textTheme.display1,
          fontSize: 30,
          fontWeight: FontWeight.w700,
          color: MyTheme.Colors.light,
        ),
      ),
    );
  }

  Widget _passwordWidget() {
    return TextFormField(
      obscureText: true,
      controller: _password,
      validator: (value) => (value.isEmpty) ? "Ingrese una contraseña" : null,
      style: style,
      cursorColor: MyTheme.Colors.light,
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
            color: MyTheme.Colors.light,
          ),
          labelText: "Contraseña",
          errorStyle: TextStyle(color: MyTheme.Colors.light),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.Colors.light)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.Colors.light)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.Colors.light)),
          labelStyle: TextStyle(color: MyTheme.Colors.light),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.Colors.light))),
    );
  }

  Widget _emailWidget() {
    return TextFormField(
      controller: _email,
      validator: (value) => (value.isEmpty) ? "Ingrese un email" : null,
      style: style,
      cursorColor: MyTheme.Colors.light,
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.email,
            color: MyTheme.Colors.light,
          ),
          labelText: "Email",
          errorStyle: TextStyle(color: MyTheme.Colors.light),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.Colors.light)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.Colors.light)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.Colors.light)),
          labelStyle: TextStyle(color: MyTheme.Colors.light),
          enabledBorder: OutlineInputBorder(
              borderSide: new BorderSide(
            color: MyTheme.Colors.light,
          ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Scaffold(
        key: _key,
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: SizedBox(),
                      ),
                      _title(),
                      SizedBox(
                        height: 20,
                      ),
                      _emailWidget(),
                      SizedBox(
                        height: 20,
                      ),
                      _passwordWidget(),
                      SizedBox(
                        height: 20,
                      ),
                      user.status == Status.Authenticating
                          ? Center(child: CircularProgressIndicator())
                          : _submitButton(user),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        alignment: Alignment.centerRight,
                        child: Text('Olvide la contraseña ?',
                            style: TextStyle(
                                color: MyTheme.Colors.light,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                      ),
                      Expanded(
                        flex: 2,
                        child: SizedBox(),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: _createAccountLabel(),
                ),
                Positioned(top: 40, left: 0, child: _backButton()),
              ],
            ),
            decoration: BoxDecoration(color: MyTheme.Colors.dark),
          ),
        )));
  }
}
