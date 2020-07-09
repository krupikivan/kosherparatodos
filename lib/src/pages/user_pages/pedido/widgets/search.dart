import 'package:flutter/material.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class Search extends StatelessWidget {
  const Search({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 10),
      child: TextField(
        onChanged: (text) {},
        style: TextStyle(color: MyTheme.Colors.primary, fontSize: 18),
        cursorColor: MyTheme.Colors.primary,
        decoration: InputDecoration(
          fillColor: MyTheme.Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: MyTheme.Colors.primary),
            borderRadius: BorderRadius.circular(18),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: MyTheme.Colors.primary),
            borderRadius: BorderRadius.circular(18),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: MyTheme.Colors.primary),
            borderRadius: BorderRadius.circular(18),
          ),
          hintText: "Search",
          hintStyle: TextStyle(color: MyTheme.Colors.primary, fontSize: 18),
          prefixIcon:
              Icon(Icons.search, color: MyTheme.Colors.primary, size: 24),
        ),
      ),
    );
  }
}
