import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/utils/validators.dart';

class InputText extends StatelessWidget {
  InputText(
      {Key key,
      this.controller,
      this.error,
      this.label,
      this.isPass,
      this.type})
      : super(key: key);
  TextStyle style = TextStyle(color: Colors.white, fontSize: 20.0);

  final TextEditingController controller;
  final String error;
  final String label;
  final bool isPass;
  final String type;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPass,
      validator: (value) =>
          (value.isEmpty || !Validator.getValidators(type, value))
              ? error
              : null,
      style: style,
      cursorColor: Colors.white,
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.email,
            color: Colors.white,
          ),
          labelText: label,
          errorStyle: TextStyle(color: Colors.white),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.white)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.white)),
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: Colors.white,
              ))),
    );
  }
}
