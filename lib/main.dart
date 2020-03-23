import 'package:flutter/material.dart';
import 'app.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Principal Main");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: App(),
    );
  }
}