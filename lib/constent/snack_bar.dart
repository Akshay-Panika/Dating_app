import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void snackBar(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.black87,
    textColor: Colors.white,
    fontSize: 12,
  );
}