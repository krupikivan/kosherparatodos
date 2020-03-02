import 'package:flutter/material.dart';
import 'package:kosherparatodos/splash_screen.dart';
import 'package:kosherparatodos/src/login_page.dart';
import 'package:kosherparatodos/src/signup_page.dart';
import 'package:kosherparatodos/src/user_info_page.dart';
import 'package:kosherparatodos/src/welcome_page.dart';
import 'package:kosherparatodos/user_repository.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserRepository.instance(),
      child: Consumer(
        builder: (context, UserRepository user, _) {
          switch (user.status) {
            case Status.Uninitialized:
              return Splash();
            case Status.Choosing:
              return WelcomePage();
            case Status.Registering:
              return SignUpPage();
            case Status.Unauthenticated:
              return LoginPage();
            case Status.Authenticating:
              return LoginPage();
            case Status.Register:
              return SignUpPage();
            case Status.Authenticated:
              return UserInfoPage(user: user.user);
          }
          return null;
        },
      ),
    );
  }
}