import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



import '../styles/colors.dart';

void navigateTo({required context, required widget}) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void navigateToFinish({required context, required widget}) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (context) => widget), (route) {
    return false;
  });
}

Widget defaultButton({
  required String text,
  required Color color,
  required Color background,
  required Function() navigate,
}) =>
    Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1, color: defaultColor)),
      child: TextButton(
        onPressed: navigate,
        child: Text(
          text,
          style: TextStyle(color: color, fontSize: 25),
        ),
      ),
    );
