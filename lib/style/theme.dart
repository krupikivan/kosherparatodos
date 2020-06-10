import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

class Colors {
  const Colors();

  // Colores de la aplicacion
  static const Color primary = Color(0xFF1A446E);
  static const Color secondary = Color(0xFF07ADA3);
  static const Color accent = Color(0xFFFBBF3B);
  static const Color white = Color(0xFFffffff);
  static const Color black = Color(0xFF464646);
  static const Color grey = Color(0xFFefefef);

  static const TextStyle headerStyle = TextStyle(color: Colors.black, fontWeight: FontWeight.w600);

  // Colores de usos
  static const Color yellowWarning = Color(0xFFffd643);
  static const Color warning = Color(0xFFCC0000);
  static const Color green = Color(0xFF86af49);

  static List<Color> productos = [
    Color(0xFFF5DFBC),
    Color(0xFFE6E9EE),
    Color(0xFFF6BE96),
    Color(0xFFCFDEAE),
    Color(0xFFF1AEB0),
    Color(0xFFF5E081),
  ].toList();
}

Color darken(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

Color lighten(Color color, [double amount = .1]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(darken(color));
  final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

  return hslLight.toColor();
}

final Colors myTheme = Colors();
