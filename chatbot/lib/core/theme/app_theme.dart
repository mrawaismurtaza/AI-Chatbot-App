import 'package:flutter/material.dart';

class AppTheme {
  ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Colors.white,
      secondary: Colors.white,
      surface: Colors.white,
      background: Colors.white,
      onPrimary: Colors.black,
      onSurface: Colors.black,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
      bodyMedium: TextStyle(color: Colors.black, fontSize: 14),
      labelLarge: TextStyle(color: Colors.white, fontSize: 16),
    ),
  );
  ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: const ColorScheme.dark(
      primary: Colors.black,
      secondary: Colors.black,
      surface: Colors.black,
      background: Colors.black,
      onSurface: Colors.white,
      onPrimary: Colors.white,
    ),
  );
}