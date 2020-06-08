import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/repository/firestore_provider.dart';
import 'package:kosherparatodos/src/repository/repo.dart';
import 'package:kosherparatodos/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class LoginPage extends StatefulWidget {
  const LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Repository repo = FirestoreProvider();
  TextEditingController _email;
  TextEditingController _password;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  TextStyle style = TextStyle(color: MyTheme.Colors.secondary, fontSize: 20.0);

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
  }

  Widget _submitButton(user) {
    return MaterialButton(
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          await _signIn(user);
        }
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

  _signIn(UserRepository user) async {
    try {
      await repo.isAuthenticated(_email.text).then((data) async {
        if (data.documents.length == 0 ||
            data.documents[0].data['estaAutenticado'] == true) {
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
      margin: const EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Todavía no tenes una cuenta?',
            style: TextStyle(
                color: MyTheme.Colors.secondary,
                fontSize: 13,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: () {
              Provider.of<UserRepository>(context, listen: false).goSignup();
            },
            child: Text(
              'Registrate',
              style: TextStyle(
                  color: MyTheme.Colors.yellowWarning,
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
      validator: (value) => (value.isEmpty) ? "Ingresa una contraseña" : null,
      style: style,
      cursorColor: MyTheme.Colors.secondary,
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.lock,
            color: MyTheme.Colors.secondary,
          ),
          labelText: "Contraseña",
          labelStyle: TextStyle(color: MyTheme.Colors.secondary),
          errorStyle: TextStyle(color: MyTheme.Colors.secondary),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MyTheme.Colors.secondary)),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MyTheme.Colors.secondary)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MyTheme.Colors.secondary)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MyTheme.Colors.secondary))),
    );
  }

  Widget _emailWidget() {
    return TextFormField(
      controller: _email,
      validator: (value) => (value.isEmpty) ? "Ingresa un email" : null,
      style: style,
      cursorColor: MyTheme.Colors.secondary,
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.email,
            color: MyTheme.Colors.secondary,
          ),
          labelText: "Email",
          errorStyle: TextStyle(color: MyTheme.Colors.secondary),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MyTheme.Colors.secondary)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MyTheme.Colors.secondary)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MyTheme.Colors.secondary)),
          labelStyle: TextStyle(color: MyTheme.Colors.secondary),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: MyTheme.Colors.secondary,
              ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [MyTheme.Colors.accent, MyTheme.Colors.primary],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.30, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Inicio de sesion'),
            leading: BackButton(
              onPressed: () {
                Provider.of<UserRepository>(context, listen: false).goWelcome();
              },
            ),
          ),
          body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height,
              child: user.status == Status.Authenticating
                  ? Center(
                      child: CircularProgressIndicator(
                      valueColor: new AlwaysStoppedAnimation<Color>(
                          MyTheme.Colors.secondary),
                    ))
                  : Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  IconButton(
                                    color: Colors.white,
                                    icon: Icon(Icons.account_circle),
                                    onPressed: () => setState(() {
                                      _email.text = 'admin@admin.com';
                                      _password.text = 'admin123';
                                    }),
                                  ),
                                  IconButton(
                                    color: Colors.white,
                                    icon: Icon(Icons.account_circle),
                                    onPressed: () => setState(() {
                                      _email.text = 'ivan@ivan.com';
                                      _password.text = 'ivan123';
                                    }),
                                  ),
                                ],
                              ),
                              _emailWidget(),
                              const SizedBox(
                                height: 20,
                              ),
                              _passwordWidget(),
                              const SizedBox(
                                height: 40,
                              ),
                              _submitButton(user),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                alignment: Alignment.centerRight,
                                child: Text('Has olvidado la contraseña?',
                                    style: TextStyle(
                                        color: MyTheme.Colors.secondary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500)),
                              ),
                            ],
                          ),
                          _createAccountLabel(),
                          const SizedBox(
                            height: 1,
                          )
                        ],
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
