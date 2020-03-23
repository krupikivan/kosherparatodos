import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/pages/admin_pages/admin_page.dart';
import 'package:kosherparatodos/src/pages/auth_pages/welcome_page.dart';
import 'app.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // initialRoute: "/",
      // routes: {
      //   // '/': (context) => WelcomePage(),
      //   '/admin': (context) => AdminPage(),

      // },
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: App(),
    );
  }
}