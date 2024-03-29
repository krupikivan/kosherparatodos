import 'package:flutter/material.dart';

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
      color: color ?? Colors.white,
      elevation: elevation ?? 15,
      shadowColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(
          name,
          style: TextStyle(fontSize: 20),
        ),
        leading: Image.asset(
          'assets/icons/usuario_100.png',
          height: 40,
          alignment: Alignment.center,
        ),
        subtitle: Text(
          estado == true ? 'Habilitado' : 'No Habilitado',
          style: TextStyle(
              fontWeight: FontWeight.w700,
              color: estado == true
                  ? Theme.of(context).primaryColorLight
                  : Theme.of(context).accentColor),
        ),
        onTap: action,
      ),
    );
  }
}
