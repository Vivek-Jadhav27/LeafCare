import 'package:flutter/material.dart';

class AppTheme{

  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: Colors.green,
    appBarTheme: const AppBarTheme(
      color: Colors.green
    )
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.green,
    appBarTheme: const AppBarTheme(
      color: Colors.green
    )
  );
  
}