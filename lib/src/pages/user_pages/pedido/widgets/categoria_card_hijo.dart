import 'package:flutter/material.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class CategoriaCardHijo extends StatelessWidget {
  const CategoriaCardHijo({Key key, this.categoria, this.action, this.selected})
      : super(key: key);
  final String categoria;
  final VoidCallback action;
  final bool selected;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: action,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: MyTheme.Colors.primary)),
        color: selected ? MyTheme.Colors.primary : MyTheme.Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
          child: Center(
            child: Text(
              categoria,
              style: TextStyle(
                  color:
                      selected ? MyTheme.Colors.white : MyTheme.Colors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}
