import 'package:flutter/material.dart';
import 'package:food_app/Constants/app_colors.dart';
import 'package:food_app/gen/fonts.gen.dart';

const textTheme = TextTheme(
  bodyLarge: TextStyle(
    fontSize: 24,
    color: Colors.black,
    fontWeight: FontWeight.w700,
  ),
  bodyMedium: TextStyle(
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.w500,
  ),
  bodySmall: TextStyle(
    fontSize: 14,
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
  labelMedium: TextStyle(
    fontFamily: FontFamily.vazirmatn,
    fontWeight: FontWeight.w500,
    fontSize: 12,
    color: Colors.black,
  ),
);

ThemeData appTheme() {
  return ThemeData(
    // AppBar
    appBarTheme: const AppBarTheme(
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
      backgroundColor: SolidColors.primary,
      elevation: 0,
    ),

    // Inputs
    inputDecorationTheme: InputDecorationTheme(
      errorStyle: textTheme.labelMedium!.copyWith(color: Colors.red),
      labelStyle: textTheme.bodySmall!.copyWith(fontSize: 14),
      contentPadding: const EdgeInsets.all(8),

      // bordres
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: SolidColors.primary),
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: SolidColors.disabled),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: SolidColors.disabled),
      ),
    ),

    bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: SolidColors.bg,
        elevation: 15,
        shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(20)),
        shadowColor: SolidColors.primary,
        modalBackgroundColor: SolidColors.bg,
        modalElevation: 15),

    dropdownMenuTheme: DropdownMenuThemeData(
      textStyle: textTheme.labelSmall,
    ),

    disabledColor: SolidColors.disabled,

    // enviroment
    scaffoldBackgroundColor: SolidColors.bg,
    canvasColor: SolidColors.bg,
    fontFamily: 'Vazirmatn',
    highlightColor: Colors.pink[50],
    primaryColor: SolidColors.primary,
    textTheme: textTheme,

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

    menuButtonTheme: MenuButtonThemeData(
      style: ButtonStyle(
        // minimumSize: MaterialStateProperty.resolveWith((states) => const Size(50, 30)),
        animationDuration: const Duration(milliseconds: 500),
        textStyle: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.pressed)) {
              return const TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.w100,
              );
            } else {
              return const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w100,
              );
            }
          },
        ),
      ),
    ),
  );
}
