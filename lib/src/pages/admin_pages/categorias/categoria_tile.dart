import 'dart:wasm';

import 'package:flutter/material.dart';

class CategoriaTile extends StatelessWidget {
  const CategoriaTile({Key key, this.name, this.action, this.esPadre})
      : super(key: key);
  final String name;
  final bool esPadre;
  final VoidCallback action;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.edit),
      title: Text(name),
      onTap: action,
      trailing: Text(esPadre ? 'Principal' : 'Secundaria'),
    );
  }
}
