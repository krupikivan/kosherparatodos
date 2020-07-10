import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/pages/auth_pages/widgets/input_text.dart';
import 'package:kosherparatodos/src/pages/auth_pages/widgets/label_text.dart';
import 'package:kosherparatodos/src/pages/auth_pages/widgets/submit_button.dart';
import 'package:kosherparatodos/src/Widget/show_toast.dart';
import 'package:kosherparatodos/src/providers/user_repository.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _name;
  TextEditingController _lastName;
  TextEditingController _email;
  TextEditingController _password;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: "");
    _lastName = TextEditingController(text: "");
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
  }

  // Widget _submitButton(UserRepository user) {
  //   return MaterialButton(
  //     child: Text(
  //       "REGISTRARSE",
  //       style: TextStyle(fontSize: 20),
  //     ),
  //     color: Theme.of(context).primaryColorLight,
  //     onPressed: () async {
  //       if (_formKey.currentState.validate()) {
  //         await user
  //             .signup(_name.text, _email.text, _password.text)
  //             .then((onValue) {
  //           user.signOutOnRegister();
  //           _key.currentState.showSnackBar(SnackBar(
  //             content: Text("Usuario creado, espere confirmacion."),
  //           ));
  //         }).catchError((e) {
  //           _key.currentState.showSnackBar(SnackBar(
  //             content: Text("Error!"),
  //           ));
  //         });
  //       }
  //     },
  //     minWidth: MediaQuery.of(context).size.width,
  //     height: 60,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Registrarse'),
            leading: BackButton(
              color: Colors.white,
              onPressed: () {
                Provider.of<UserRepository>(context, listen: false).goWelcome();
              },
            ),
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height,
            child: user.status == Status.Registering
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Center(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          SizedBox(height: 40),
                          InputText(
                            controller: _name,
                            type: 'txt',
                            label: "Nombre",
                            isPass: false,
                            error: "Ingrese nombre",
                          ),
                          SizedBox(height: 25),
                          InputText(
                            controller: _lastName,
                            type: 'txt',
                            label: "Apellido",
                            isPass: false,
                            error: "Ingrese apellido",
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          InputText(
                            controller: _email,
                            type: 'email',
                            label: "Email",
                            isPass: false,
                            error: "Ingrese email",
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          InputText(
                            controller: _password,
                            type: 'pass',
                            label: "Contraseña",
                            isPass: true,
                            error:
                                "Contraseña debe tener 8 caracteres 1 mayuscula y numeros",
                          ),
                          SizedBox(height: 25),
                          SubmitButton(
                            text: "REGISTRARSE",
                            action: () => _signUp(user),
                          ),
                          SizedBox(height: 30),
                          Labeltext(
                            action: () => Provider.of<UserRepository>(context,
                                    listen: false)
                                .goLogin(),
                            label: 'Ya tienes una cuenta? Iniciar Sesion!',
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

  void _signUp(UserRepository user) async {
    if (_formKey.currentState.validate()) {
      try {
        await user.signup(
            _name.text, _lastName.text, _email.text, _password.text);
        await user.signOutOnRegister();
        ShowToast().show('Usuario creado', 5);
      } catch (e) {
        await user.signOutOnRegister();
        ShowToast().show('El usuario ya existe', 5);
      }
    } else {
      ShowToast().show('Faltan datos', 5);
    }
  }
}
