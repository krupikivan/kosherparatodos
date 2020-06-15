import 'package:flutter/material.dart';
import 'package:kosherparatodos/src/utils/validators.dart';
import 'package:kosherparatodos/style/theme.dart' as MyTheme;

class InputText extends StatelessWidget {
  InputText({Key key, this.controller, this.error, this.label, this.isPass})
      : super(key: key);
  TextStyle style = TextStyle(color: MyTheme.Colors.white, fontSize: 20.0);

  final TextEditingController controller;
  final String error;
  final String label;
  final bool isPass;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPass,
      validator: (value) =>
          (value.isEmpty || !Validator.getValidators(label, value))
              ? error
              : null,
      style: style,
      cursorColor: MyTheme.Colors.white,
      decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.email,
            color: MyTheme.Colors.white,
          ),
          labelText: label,
          errorStyle: TextStyle(color: MyTheme.Colors.white),
          focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MyTheme.Colors.white)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MyTheme.Colors.white)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: MyTheme.Colors.white)),
          labelStyle: TextStyle(color: MyTheme.Colors.white),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: MyTheme.Colors.white,
              ))),
    );
  }
}
