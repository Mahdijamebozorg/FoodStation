import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      // accentColor: Colors.amber,
      canvasColor: const Color.fromRGBO(255, 254, 229, 1),
      fontFamily: 'Raleway',
      highlightColor: Colors.pink[50],
      primaryColor: Colors.pink,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(
          fontSize: 24,
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
        bodySmall: TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w100,
        ),
        //titles
        titleMedium: TextStyle(
          fontFamily: '(50)',
          fontSize: 30,
          color: Colors.white,
        ),
      ),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink)
          .copyWith(background: Colors.white, onBackground: Colors.black54));
}
