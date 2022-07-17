import 'package:flutter/material.dart';

final lightTheme = ThemeData(
  primarySwatch: Colors.blue,
  scaffoldBackgroundColor: Colors.blue,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryTextTheme: TextTheme(
    bodyText1: TextStyle(fontFamily: "Courier", fontWeight: FontWeight.bold),
    bodyText2: TextStyle(fontFamily: "Courier", color: Colors.white70),
  ),
);
