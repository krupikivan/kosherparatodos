import 'package:flutter/material.dart';
import 'app.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Principal Main");

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return MaterialApp(
      key: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          textTheme: GoogleFonts.openSansTextTheme(textTheme),
          fontFamily: 'OpenSans'),
      home: App(),
    );
  }
}
