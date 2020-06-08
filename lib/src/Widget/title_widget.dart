import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class TitleLabel extends StatelessWidget {
  const TitleLabel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Kosher Para Todos',
            style: GoogleFonts.portLligatSans(
              textStyle: Theme.of(context).textTheme.headline4,
              fontSize: 40,
              fontWeight: FontWeight.w700,
              color: MyTheme.Colors.secondary,
            ),
          ),
        ),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Carnes y lacteos kosher al costo',
            style: GoogleFonts.portLligatSans(
              textStyle: Theme.of(context).textTheme.headline4,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: MyTheme.Colors.secondary,
            ),
          ),
        ),
      ],
    );
  }
}
