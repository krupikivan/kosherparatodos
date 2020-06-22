import 'package:flutter/material.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class ClienteCardWidget extends StatelessWidget {
  final String name;
  final bool estado;
  final double elevation;
  final Color color;
  final VoidCallback action;
  const ClienteCardWidget(
      {Key key,
      this.name,
      this.action,
      this.estado,
      this.elevation,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color ?? MyTheme.Colors.white,
      elevation: elevation ?? 10,
      shadowColor: Colors.black38,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        title: Text(
          name,
          style: TextStyle(fontSize: 15),
        ),
        leading: Icon(
          Icons.account_circle,
          size: 40,
          color: MyTheme.Colors.black,
        ),
        subtitle: Text(
          estado == true ? 'Habilitado' : 'No Habilitado',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: estado == true
                  ? MyTheme.Colors.secondary
                  : MyTheme.Colors.accent),
        ),
        onTap: action,
      ),
    );
  }
}
