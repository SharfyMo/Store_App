import 'package:flutter/material.dart';
import 'package:sales_project/shared/colors.dart';

showSnakBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: bTNgreen,
    content: Text(text),
    // duration: const Duration(days: 1),
    action:
        SnackBarAction(label: "Close", textColor: Colors.red, onPressed: () {}),
  ));
}
