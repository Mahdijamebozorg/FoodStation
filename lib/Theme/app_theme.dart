import 'package:flutter/material.dart';
import 'package:food_app/Constants/app_colors.dart';
import 'package:food_app/gen/fonts.gen.dart';

ThemeData appTheme() {
  return ThemeData(
    scaffoldBackgroundColor: SolidColors.bg,
    // accentColor: Colors.amber,
    canvasColor: SolidColors.bg,
    fontFamily: 'Vazirmatn',
    highlightColor: Colors.pink[50],
    primaryColor: SolidColors.primary,
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
        fontSize: 30,
        color: Colors.white,
      ),
      // lable
      displayLarge: TextStyle(
        fontFamily: FontFamily.sGKara,
        fontSize: 64,
        color: Colors.white,
      ),
      displayMedium: TextStyle(
        fontFamily: FontFamily.vazirmatn,
        fontWeight: FontWeight.w700,
        fontSize: 24,
        color: Colors.white,
      ),
      displaySmall: TextStyle(
        fontFamily: FontFamily.vazirmatn,
        fontWeight: FontWeight.w500,
        fontSize: 16,
        color: Colors.white,
      ),
    ),
    popupMenuTheme: const PopupMenuThemeData(
      textStyle: TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontWeight: FontWeight.w100,
      ),
    ),
    snackBarTheme:
        const SnackBarThemeData(backgroundColor: SolidColors.primary),
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink).copyWith(
        background: Colors.white,
        onBackground: Colors.black54,
        primary: SolidColors.primary),

    menuButtonTheme: MenuButtonThemeData(style:
        ButtonStyle(textStyle: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.pressed)) {
        return const TextStyle(
          fontSize: 18,
          color: Colors.black,
          fontWeight: FontWeight.w100,
        );
      } else {
        return const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w100,
        );
      }
    }))),
  );
}
