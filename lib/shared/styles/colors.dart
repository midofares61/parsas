import 'dart:ui';

import 'package:flutter/material.dart';

const defaultColor = Color.fromRGBO(63, 81, 181, 1);

const secondeColor = Color.fromRGBO(63, 81, 181, 0.7);

const thirdColor = Color.fromRGBO(193, 191, 231, 1);

const orderColor = Color.fromRGBO(132, 157, 208, 1);

const darkColor = Color.fromRGBO(11, 11, 11, 1);

ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: defaultColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: defaultColor,
    ));

ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Color.fromRGBO(22, 22, 22, 1),
    appBarTheme: AppBarTheme(
      backgroundColor: darkColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: defaultColor,
    ));
