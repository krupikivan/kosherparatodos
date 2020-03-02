import 'package:flutter/material.dart';
import 'home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // initialRoute: "/",
      // routes: {
      //   '/': (context) => WelcomePage(),
      //   '/home': (context) => HomePage(),
      //   '/login': (context) => LoginPage(),
      //   '/signup': (context) => SignUpPage(),
      // },
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: HomePage(),
    );
  }
}