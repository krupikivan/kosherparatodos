import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 10),
      child: TextField(
        onChanged: (text) {},
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(18),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(18),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(18),
          ),
          hintText: "Buscar",
          hintStyle:
              TextStyle(color: Theme.of(context).primaryColor, fontSize: 18),
          prefixIcon: Icon(Icons.search,
              color: Theme.of(context).primaryColor, size: 24),
        ),
      ),
    );
  }
}
