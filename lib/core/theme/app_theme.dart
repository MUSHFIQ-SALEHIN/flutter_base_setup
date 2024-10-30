import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: Colors.blue,
      brightness: Brightness.light,
      appBarTheme: const AppBarTheme(color: Colors.blue),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primaryColor: Colors.blueGrey,
      brightness: Brightness.dark,
      appBarTheme: const AppBarTheme(color: Colors.blueGrey),
    );
  }
}
