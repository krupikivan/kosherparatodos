import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/pages/auth_pages/widgets/input_text.dart';
import 'package:kosherparatodos/src/pages/auth_pages/widgets/submit_button.dart';
import 'package:kosherparatodos/src/Widget/show_toast.dart';
import 'package:kosherparatodos/src/providers/user_repository.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _email;
  TextEditingController _password;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: "");
    _password = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context);
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(color: Theme.of(context).primaryColor),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('Inicio de sesion'),
            leading: BackButton(
              color: Colors.white,
              onPressed: () {
                Provider.of<UserRepository>(context, listen: false).goWelcome();
              },
            ),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            height: MediaQuery.of(context).size.height,
            child: user.status == Status.Authenticating
                ? Center(
                    child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ))
                : Center(
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: <Widget>[
                          InputText(
                            controller: _email,
                            isPass: false,
                            type: 'email',
                            error: "Ingresa un email",
                            label: "Email",
                          ),
                          SizedBox(height: 25),
                          InputText(
                            controller: _password,
                            isPass: true,
                            type: 'pass',
                            error:
                                "Contraseña debe tener 8 caracteres 1 mayuscula y numeros",
                            label: "Contraseña",
                          ),
                          SizedBox(height: 25),
                          SubmitButton(
                            text: 'INGRESAR',
                            action: () => _formKey.currentState.validate()
                                ? user
                                    .beforeSignIn(_email.text, _password.text)
                                    .then((value) => true,
                                        onError: (e) => ShowToast().show(e, 5))
                                    .catchError((e) => ShowToast().show(e, 5))
                                : null,
                          ),
                          SizedBox(height: 15),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            alignment: Alignment.center,
                            child: Text('Has olvidado la contraseña?',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300)),
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
