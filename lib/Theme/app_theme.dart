import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      // accentColor: Colors.amber,
      canvasColor: const Color.fromRGBO(255, 254, 229, 1),
      fontFamily: 'Raleway',
      highlightColor: Colors.pink[50],
      primaryColor: Colors.pink,
      textTheme: ThemeData.light().textTheme.copyWith(
            //drawer
            bodyLarge: const TextStyle(fontSize: 23, color: Colors.black),
            //body
            bodyMedium: const TextStyle(
                fontSize: 21, color: Colors.black, fontWeight: FontWeight.w600),
            //titles
            titleMedium: const TextStyle(
              fontFamily: '(50)',
              fontSize: 30,
              color: Colors.white,
            ),
          ),
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink)
          .copyWith(background: Colors.white));
}
