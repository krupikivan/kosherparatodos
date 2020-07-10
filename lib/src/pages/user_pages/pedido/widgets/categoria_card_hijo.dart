import 'package:flutter/material.dart';

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
            side: BorderSide(color: Theme.of(context).primaryColor)),
        color: selected ? Theme.of(context).primaryColor : Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
          child: Center(
            child: Text(
              categoria,
              style: TextStyle(
                  color:
                      selected ? Colors.white : Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}
