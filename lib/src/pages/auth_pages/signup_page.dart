import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/Widget/title_widget.dart';
import 'package:kosherparatodos/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  TextStyle style = TextStyle(color: MyTheme.Colors.secondary, fontSize: 20.0);
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

  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false}) {
    return TextFormField(
        obscureText: isPassword,
        controller: controller,
        validator: (value) => (value.isEmpty) ? "Ingrese $title" : null,
        style: style,
        cursorColor: MyTheme.Colors.secondary,
        decoration: InputDecoration(
          labelText: title,
          labelStyle: TextStyle(color: MyTheme.Colors.secondary),
          errorStyle: TextStyle(color: MyTheme.Colors.secondary),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MyTheme.Colors.secondary)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MyTheme.Colors.secondary)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MyTheme.Colors.yellowWarning)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MyTheme.Colors.secondary)),
        ));
  }

  Widget _submitButton(UserRepository user) {
    return MaterialButton(
      child: Text(
        "REGISTRARSE",
        style: TextStyle(fontSize: 20),
      ),
      color: MyTheme.Colors.secondary,
      onPressed: () async {
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
      minWidth: MediaQuery.of(context).size.width,
      height: 60,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
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
            'Ya tienes una cuenta?',
            style: TextStyle(
                color: MyTheme.Colors.secondary,
                fontSize: 13,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 5,
          ),
          InkWell(
            onTap: () {
              Provider.of<UserRepository>(context, listen: false).goLogin();
            },
            child: Text(
              'Ingresar',
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

  Widget _emailPasswordWidget() {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _entryField(
            "Nombre",
            _name,
          ),
          SizedBox(
            height: 20,
          ),
          _entryField("Email", _email),
          SizedBox(
            height: 20,
          ),
          _entryField("Contraseña", _password, isPassword: true),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);

    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
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
            leading: BackButton(
              onPressed: () {
                Provider.of<UserRepository>(context, listen: false).goWelcome();
              },
            ),
          ),
          body: SingleChildScrollView(
            // physics: NeverScrollableScrollPhysics(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: MediaQuery.of(context).size.height,
              child: user.status == Status.Authenticating
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            MyTheme.Colors.secondary),
                      ),
                    )
                  : Form(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          //  SizedBox(
                          //   height: 20,
                          // ),
                          TitleLabel(),
                          Column(
                            children: <Widget>[
                              _emailPasswordWidget(),
                              SizedBox(
                                height: 40,
                              ),
                              _submitButton(user)
                            ],
                          ),
                          _loginAccountLabel(),
                          SizedBox(
                            height: 10,
                          ),
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
