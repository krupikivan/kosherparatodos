import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// class Colors {
//   const Colors();

//   // Colores de la aplicacion
//   static const Color primary = Color(0xFF1A446E);
//   static const Color secondary = Color(0xFF07ADA3);
//   static const Color accent = Color(0xFFFBBF3B);
//   static const Color white = Color(0xFFffffff);
//   static const Color black = Color(0xFF464646);
//   static const Color grey = Color(0xFFefefef);
//   static const Color darkGrey = Color(0xFF615e59);

//   static const TextStyle headerStyle =
//       TextStyle(color: Colors.black, fontWeight: FontWeight.w600);

//   // Colores de usos
//   static const Color yellowWarning = Color(0xFFffd643);
//   static const Color warning = Color(0xFFCC0000);
//   static const Color green = Color(0xFF86af49);

//   static List<Color> productos = [
//     Color(0xFFF5DFBC),
//     Color(0xFFE6E9EE),
//     Color(0xFFF6BE96),
//     Color(0xFFCFDEAE),
//     Color(0xFFF1AEB0),
//     Color(0xFFF5E081),
//   ].toList();
// }

// Color darken(Color color, [double amount = .1]) {
//   assert(amount >= 0 && amount <= 1);

//   final hsl = HSLColor.fromColor(color);
//   final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

//   return hslDark.toColor();
// }

// Color lighten(Color color, [double amount = .1]) {
//   assert(amount >= 0 && amount <= 1);

//   final hsl = HSLColor.fromColor(darken(color));
//   final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

//   return hslLight.toColor();
// }

ThemeData themeData() {
  return ThemeData(
    fontFamily: GoogleFonts.muli().fontFamily,
    primaryColor: Color(0xFF1A446E),
    errorColor: Color(0xFFCC0000),
    primaryColorLight: Color(0xFF07ADA3),
    backgroundColor: Color(0xFFffffff),
    accentColor: Color(0xFFFBBF3B),
    dividerColor: Colors.grey[300],
    appBarTheme: AppBarTheme(
      textTheme: TextTheme(
          headline6: TextStyle(
        fontFamily: GoogleFonts.muli().fontFamily,
        fontSize: 20,
      )),
      brightness: Brightness.light,
      color: Colors.grey,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
    ),
  );
}

// import 'package:flutter/material.dart';
// ThemeData themeData() {
//   TextTheme _basicTextTheme(TextTheme basic) {
//     return basic.copyWith(
//       headline1: basic.headline1.copyWith(
//           fontFamily: 'RobotoCondensed',
//           fontSize: 24,
//           color: Colors.grey[600],
//           fontWeight: FontWeight.w600),
//       headline2: basic.headline1.copyWith(
//         fontFamily: 'RobotoCondensed',
//         fontSize: 20,
//         color: Color.fromRGBO(29, 113, 184, 1),
//       ),
//       headline3: basic.bodyText1.copyWith(
//           fontFamily: 'RobotoCondensed',
//           fontSize: 18,
//           color: Colors.grey[600],
//           fontWeight: FontWeight.w600),
//       headline4: basic.bodyText1.copyWith(
//         fontFamily: 'RobotoCondensed',
//         fontSize: 16,
//         color: Colors.grey[800],
//       ),
//       headline5: basic.bodyText1.copyWith(
//         fontFamily: 'RobotoCondensed',
//         fontSize: 18,
//         fontWeight: FontWeight.bold,
//         color: Color(0xff72bfff),
//       ),
//       headline6: basic.bodyText2.copyWith(
//         fontFamily: 'RobotoCondensed',
//         fontSize: 17,
//         fontWeight: FontWeight.bold,
//         color: Colors.white,
//       ),
//       caption: basic.bodyText1.copyWith(
//         fontFamily: 'RobotoCondensed',
//         fontSize: 25,
//         color: Colors.grey[600],
//       ),
//       bodyText1: basic.bodyText1.copyWith(
//         fontFamily: 'RobotoCondensed',
//         fontSize: 18,
//         color: Colors.black,
//       ),
//       bodyText2: basic.bodyText1.copyWith(
//         fontFamily: 'RobotoCondensed',
//         fontSize: 16,
//         color: Colors.black,
//       ),
//     );
//   }

//   final ThemeData base = ThemeData.light();
//   return base.copyWith(
//     textTheme: _basicTextTheme(base.textTheme),
//     primaryColor: Color(0xff1d72b7),
//     backgroundColor: Colors.grey[800],
//     primaryColorLight: Color(0xff8ecbfd),
//     primaryColorDark: Color.fromRGBO(15, 83, 137, 1),
//     hoverColor: Color.fromRGBO(0, 0, 0, 0.7),
//     disabledColor: Colors.grey[600],
//     highlightColor: Color.fromRGBO(200, 205, 208, 1), //Icon from bottom bar nav
//     accentColor: Color.fromRGBO(255, 216, 52, 1), //Color from notification icon
//     errorColor: Color(0xffed1c24),
//   );
// }
