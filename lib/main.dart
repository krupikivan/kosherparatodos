import 'dart:io';

import 'package:flutter/material.dart';
import 'app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();

  // final FirebaseApp app = await FirebaseApp.configure(
  //   name: 'test',
  //   options: FirebaseOptions(
  //     googleAppID: (Platform.isIOS)
  //         ? '1:159623150305:ios:4a213ef3dbd8997b'
  //         : '1:159623150305:android:ef48439a0cc0263d',
  //     gcmSenderID: '159623150305',
  //     apiKey: '',
  //     projectID: 'kosherparatodos',
  //   ),
  // );
  // final FirebaseStorage storage = FirebaseStorage(
  //     app: app, storageBucket: 'gs://kosherparatodos-e8111.appspot.com');
  runApp(MyApp(/*storage: storage*/));
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey(debugLabel: "Principal");
  // final FirebaseStorage storage;

  MyApp({
    Key key,
    /*this.storage*/
  }) : super(key: key);

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
