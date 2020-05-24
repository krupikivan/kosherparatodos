import 'package:flutter/cupertino.dart';

class Colors{

  const Colors();

  static const Color primary = const Color(0xFF153750);
  static const Color dark = const Color(0xFFC43617c);
  static const Color yellowWarning = const Color(0xFFffd643);
  static const Color warning = const Color(0xFFCC0000);
  static const Color check = const Color(0xFF86af49);
  static const Color light = const Color(0xFFf7f7f7);
  static const Color minLight = const Color(0xFFf7f7f7);
  static const Color secondaryColor = const Color(0xFFf7f7f7);

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

    final hsl = HSLColor.fromColor(darken(color, 0.1));
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

class Fonts{

  static const String primaryFont = "WorkSansMedium";

}

final myTheme = Colors();