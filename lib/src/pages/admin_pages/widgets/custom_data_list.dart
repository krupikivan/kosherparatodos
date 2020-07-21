import 'package:flutter/material.dart';

class CustomDataList extends StatelessWidget {
  final String dato1;
  final String dato2;
  final String campo;
  final bool multiLines;

  const CustomDataList(
      {Key key, this.dato1, this.campo, this.multiLines, this.dato2})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      isThreeLine: multiLines ?? false,
      title: Text(dato1),
      subtitle: dato2 != null && dato2 != ""
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                multiLines == false
                    ? SizedBox()
                    : Text(
                        dato2,
                        style: TextStyle(color: Colors.black),
                      ),
                Text(campo),
              ],
            )
          : SizedBox(),
    );
  }
}
