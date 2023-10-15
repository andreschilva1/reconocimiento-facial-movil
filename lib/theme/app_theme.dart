import 'package:flutter/material.dart';

class AppTheme {
  static Color primaryColor = Colors.blue[700]!;

  static ThemeData lightTheme = ThemeData.light().copyWith(
      primaryColor: primaryColor,
      appBarTheme: AppBarTheme(
        color: primaryColor,
        elevation: 0,
      ),
  
      //FloatingActionButton
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryColor, elevation: 5),

      //elevatedButtonTheme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor, elevation: 2),
      ));

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: primaryColor,
    appBarTheme: AppBarTheme(
      color: primaryColor,
      elevation: 0,
    ),
  );
}
