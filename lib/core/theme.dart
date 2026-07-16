import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Color(0xFFB7202E),
      onPrimary: Color.fromARGB(255, 248, 198, 198),
      secondary: Color(0xFF1A1A1A),
      onSecondary: Color.fromARGB(255, 255, 255, 255),
      surface: Color.fromARGB(255, 240, 240, 240),
      surfaceBright: Color.fromARGB(255, 214, 210, 210)
    ),
  );
}