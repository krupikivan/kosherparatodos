import 'package:flutter/material.dart';
import 'app.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
      home: App(),
    );
  }
}