import 'package:flutter/material.dart';

class MainThemeData {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blueAccent,
    primaryColorBrightness: Brightness.light,
    primaryColorLight: Colors.blueAccent.shade100,
    primaryColorDark: Colors.blueAccent.shade700,
    accentColor: Colors.black54,
    scaffoldBackgroundColor: Color(0xfff0f0f0),
    backgroundColor: Color(0xfff0f0f0),
    toggleableActiveColor: Colors.blueAccent,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
    ),
  );
  static ThemeData dartTheme = ThemeData.dark();

  static ThemeData currentTheme = lightTheme;

  static init(ThemeData themeData) {
    currentTheme = themeData;
  }
}
