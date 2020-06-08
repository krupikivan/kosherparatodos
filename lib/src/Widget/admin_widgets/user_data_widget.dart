import 'package:flutter/material.dart';

class UserDataWidget extends StatelessWidget {
  final String dato1;
  final String dato2;
  final String campo;
  final bool multiLines;

  const UserDataWidget(
      {Key key, this.dato1, this.campo, this.multiLines, this.dato2})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: multiLines == true ? true : false,
      title: Text(dato1),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          multiLines == false ? SizedBox() : Text(dato2),
          Text(campo),
        ],
      ),
    );
  }
}
