import 'package:flutter/material.dart';
import 'package:kosherparatodos/splash_screen.dart';
import 'package:kosherparatodos/src/pages/auth_pages/export.dart';
import 'package:kosherparatodos/src/pages/home_pages/user_page.dart';
import 'package:kosherparatodos/user_repository.dart';
import 'package:provider/provider.dart';

import 'src/pages/auth_pages/export.dart';
import 'src/pages/auth_pages/export.dart';
import 'src/pages/auth_pages/export.dart';

class App extends StatelessWidget {
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
              return UserPage(user: user.user);
          }
          return null;
        },
      ),
    );
  }
}