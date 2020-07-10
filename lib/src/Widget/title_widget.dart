import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TitleLabel extends StatelessWidget {
  const TitleLabel({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          FontAwesomeIcons.truck,
          color: Colors.white,
          size: 35,
        ),
        SizedBox(height: 25),
        RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            text: 'Kosher Para Todos',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 5),
        RichText(
          textAlign: TextAlign.left,
          text: TextSpan(
            text: 'Carnes y lacteos kosher al costo',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w300,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
