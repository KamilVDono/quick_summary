import 'package:flutter/material.dart';

class Utils{
  static int currentDateMilliseconds() {
    return (new DateTime.now()).millisecondsSinceEpoch;
  }

  static DateTime dateTimeFromMilliseconds(int milliseconds) =>
      DateTime.fromMillisecondsSinceEpoch(milliseconds);

  static void showToast(BuildContext context, String text) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }
}