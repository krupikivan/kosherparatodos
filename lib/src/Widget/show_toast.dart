import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ShowToast{

  show(String msg, time){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: time,
        backgroundColor: Colors.greenAccent
    );
  }

}