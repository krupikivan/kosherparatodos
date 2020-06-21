import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Field extends StatelessWidget {
  const Field({
    Key key,
    @required TextEditingController controller,
    @required bool isNum,
    @required String description,
  })  : _controller = controller,
        _isNum = isNum,
        _description = description,
        super(key: key);

  final TextEditingController _controller;
  final bool _isNum;
  final String _description;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          filled: true,
        ),
        keyboardType:
            _isNum == true ? TextInputType.number : TextInputType.text,
        inputFormatters:
            _isNum == true ? [WhitelistingTextInputFormatter.digitsOnly] : null,
        controller: _controller,
      ),
      subtitle: Text(_description),
    );
  }
}
