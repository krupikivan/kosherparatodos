import 'package:flutter/material.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class TitleDetailPage extends StatelessWidget {
  const TitleDetailPage({Key key, this.title, this.subtitle}) : super(key: key);
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
            color: MyTheme.Colors.primary,
            fontWeight: FontWeight.w500,
            fontSize: 25),
      ),
      subtitle: subtitle == null
          ? SizedBox()
          : Text(
              subtitle,
              style: TextStyle(
                  fontSize: 15,
                  color: MyTheme.Colors.black,
                  fontWeight: FontWeight.w100),
            ),
    );
  }
}
