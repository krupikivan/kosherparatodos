import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kosherparatodos/src/Widget/login_button.dart';
import 'package:kosherparatodos/src/Widget/title_widget.dart';
import 'package:kosherparatodos/src/repository/repo.dart';
import 'package:kosherparatodos/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

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
      color: MyTheme.Colors.secondaryColor,
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
                  Icon(Icons.keyboard_arrow_left, color: MyTheme.Colors.secondaryColor),
            ),
            Text('Volver',
                style: TextStyle(
                    color: MyTheme.Colors.secondaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _submitButton(user) {
    return MaterialButton(
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          await _signIn(user);
        }
      },
      color: MyTheme.Colors.secondaryColor,
      child: Text(
        'INGRESAR',
        style: TextStyle(fontSize: 20),
      ),
      minWidth: MediaQuery.of(context).size.width,
      height: 60,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                color: MyTheme.Colors.secondaryColor,
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
                  color: MyTheme.Colors.secondaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  Widget _passwordWidget() {
    return TextFormField(
      obscureText: true,
      controller: _password,
      validator: (value) => (value.isEmpty) ? "Ingrese una contraseña" : null,
      style: style,
      cursorColor: MyTheme.Colors.secondaryColor,
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
            color: MyTheme.Colors.secondaryColor,
          ),
          labelText: "Contraseña",
          errorStyle: TextStyle(color: MyTheme.Colors.secondaryColor),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.Colors.secondaryColor)),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.Colors.secondaryColor)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.Colors.secondaryColor)),
          labelStyle: TextStyle(color: MyTheme.Colors.secondaryColor),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.Colors.secondaryColor))),
    );
  }

  Widget _emailWidget() {
    return TextFormField(
      controller: _email,
      validator: (value) => (value.isEmpty) ? "Ingrese un email" : null,
      style: style,
      cursorColor: MyTheme.Colors.secondaryColor,
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.email,
            color: MyTheme.Colors.secondaryColor,
          ),
          labelText: "Email",
          errorStyle: TextStyle(color: MyTheme.Colors.secondaryColor),
          focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.Colors.secondaryColor)),
          errorBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.Colors.secondaryColor)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyTheme.Colors.secondaryColor)),
          labelStyle: TextStyle(color: MyTheme.Colors.secondaryColor),
          enabledBorder: OutlineInputBorder(
              borderSide: new BorderSide(
            color: MyTheme.Colors.secondaryColor,
          ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Scaffold(
      backgroundColor: MyTheme.Colors.primary,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TitleLabel(),
                Column(
                  children: <Widget>[
                    _emailWidget(),
                    SizedBox(height: 20,),
                _passwordWidget(),
                user.status == Status.Authenticating
                    ? Center(
                        child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            MyTheme.Colors.secondaryColor),
                      ))
                    : _submitButton(user),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.centerRight,
                  child: Text('Olvide la contraseña ?',
                      style: TextStyle(
                          color: MyTheme.Colors.secondaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
