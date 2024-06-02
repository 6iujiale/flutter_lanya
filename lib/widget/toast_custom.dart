import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MyCustomToast {
  final String msg;
  int? loadingTime;

  MyCustomToast({required this.msg, this.loadingTime = 0});

  Future<void> showShortToast() async {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.pink,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    await Future.delayed(Duration(seconds: loadingTime!));
  }

  Future<void> showLongToast() async {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.pink,
      textColor: Colors.white,
      fontSize: 16.0,
    );
    await Future.delayed(Duration(seconds: loadingTime!));
  }
}
