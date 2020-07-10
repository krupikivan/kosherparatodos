import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kosherparatodos/src/utils/validators.dart';

class InputUserData extends StatelessWidget {
  const InputUserData(
      {Key key, this.controller, this.title, this.isNum, this.error, this.icon})
      : super(key: key);
  final TextEditingController controller;
  final String title;
  final IconData icon;
  final bool isNum;
  final String error;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value != "" && !Validator.validateUserData(isNum, value)) {
            return error;
          }
          return null;
        },
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12.0),
        cursorColor: Theme.of(context).primaryColor,
        keyboardType: isNum ? TextInputType.number : TextInputType.text,
        inputFormatters:
            isNum ? [WhitelistingTextInputFormatter.digitsOnly] : null,
        decoration: InputDecoration(
            prefixIcon: icon != null
                ? Icon(
                    icon,
                    color: Theme.of(context).primaryColor,
                  )
                : SizedBox(),
            labelText: title,
            errorStyle: TextStyle(color: Theme.of(context).primaryColor),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Theme.of(context).primaryColor)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Theme.of(context).primaryColor)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Theme.of(context).primaryColor)),
            labelStyle: TextStyle(color: Theme.of(context).primaryColor),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                ))),
      ),
    );
  }
}
