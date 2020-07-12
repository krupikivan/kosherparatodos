import 'package:flutter/material.dart';

class EmptyData extends StatelessWidget {
  const EmptyData({Key key, this.text}) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(text, style: TextStyle(fontSize: 20)),
    );
  }
}
