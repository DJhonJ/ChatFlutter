
import 'package:flutter/material.dart';

class AppTheme {
  static Color colorPrimary = const Color(0xff6A5ACD);
  static Color colorPrimaryMedium = const Color(0xffa296ef);
  static Color colorPrimaryDark = const Color(0xff483D8B);
  static Color colorBlack = const Color(0xff2A2A2A);
  static Color colorGrey = const Color(0xfff1f0f0);

  static ThemeData theme = ThemeData(
    primaryColor: colorPrimary,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: colorPrimary
      )
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: colorPrimary
    ),
    appBarTheme: AppBarTheme(
      //color: colorBlack,
      foregroundColor: colorBlack,
      backgroundColor: Colors.white
    ),
    scaffoldBackgroundColor: Colors.white
  );
}