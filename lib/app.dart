import 'package:flutter/material.dart';
import 'package:kosherparatodos/splash_screen.dart';
import 'package:kosherparatodos/src/pages/admin_pages/admin_page.dart';
import 'package:kosherparatodos/src/pages/auth_pages/export.dart';
import 'package:kosherparatodos/src/pages/user_pages/home_menu.dart';
import 'package:kosherparatodos/src/providers/preferences.dart';
import 'package:kosherparatodos/src/repository/firebase_storage.dart';
import 'package:kosherparatodos/src/providers/user_repository.dart';
import 'package:provider/provider.dart';
import 'src/pages/auth_pages/export.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Preferences _prefs = Preferences();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserRepository.instance()),
        ChangeNotifierProvider(create: (_) => FireStorageService.instance()),
      ],
      child: Consumer(
        builder: (context, UserRepository user, _) {
          // await user.getAdminList();
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
              if (user.adminList.contains(user.user.uid) || _prefs.isAdmin) {
                _prefs.isAdmin = true;
                return AdminPage(user: user.user);
              } else {
                _prefs.isAdmin = false;
                return UserPage(user: user.user);
              }
          }
          return null;
        },
      ),
    );
  }
}
