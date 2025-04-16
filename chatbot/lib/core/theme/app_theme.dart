import 'package:flutter/material.dart';

class AppTheme {
  ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Colors.white,
      secondary: Colors.blueAccent,
      surface: Colors.white,
      background: Colors.white,
      onPrimary: Colors.black,
      onSurface: Colors.black,
      tertiary: Colors.blueGrey, // Changed for better contrast
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
      secondary: Colors.blueAccent,
      surface: Colors.black,
      background: Colors.black,
      onSurface: Colors.white,
      onPrimary: Colors.white,
      tertiary: Colors.blueGrey, // Changed for better contrast
    ),
  );
}