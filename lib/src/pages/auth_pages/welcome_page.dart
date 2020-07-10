import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/pages/auth_pages/widgets/label_text.dart';
import 'package:kosherparatodos/src/pages/auth_pages/widgets/submit_button.dart';
import 'package:kosherparatodos/src/Widget/title_widget.dart';
import 'package:kosherparatodos/src/providers/user_repository.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatelessWidget {
  final String title;

  const WelcomePage({Key key, this.title}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserRepository>(context, listen: false);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 35),
          height: MediaQuery.of(context).size.height,
          decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TitleLabel(),
              Column(
                children: <Widget>[
                  SubmitButton(
                    action: () => user.goLogin(),
                    text: 'INGRESAR',
                  ),
                  SizedBox(height: 30),
                  Labeltext(
                    action: () =>
                        Provider.of<UserRepository>(context, listen: false)
                            .goSignup(),
                    label: 'No tenes cuenta? Registrate!',
                  ),
                  // _goSignUp(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _goSignUp(context) {
  //   return InkWell(
  //     onTap: () {
  //       Provider.of<UserRepository>(context, listen: false).goSignup();
  //     },
  //     child: Text(
  //       'No tenes cuenta? Registrate!',
  //       style: TextStyle(fontSize: 15, color: Colors.white),
  //     ),
  //   );
  // }
}
