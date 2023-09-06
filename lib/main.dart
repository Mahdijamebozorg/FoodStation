import 'package:flutter/material.dart';
import 'package:food_app/Controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:food_app/Controller/comment_controller.dart';
import 'package:food_app/Controller/food_controller.dart';
import 'package:food_app/Controller/user_controller.dart';
import 'package:food_app/Routs/pages.dart';
import 'package:food_app/Theme/app_theme.dart';
import 'package:food_app/View/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // put dependecies
  Get.put(AuthController());
  Get.put(UserController());
  Get.put(FoodController());
  Get.put(CommentController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale("fa", ""),
      ],

      debugShowCheckedModeBanner: false,
      title: 'Food App',
      theme: appTheme(),
      getPages: AppPages.pages,
      // initialBinding: MainBinding(),
      initialRoute: '/login',
      // routes: {
      //   '/home': (_) => const HomeScreen(),
      //   CategoryScreen.routeName: (_) => const CategoryScreen(),
      //   FoodScreen.routeName: (_) => const FoodScreen(),
      //   SettingScreen.routeName: (_) => const SettingScreen(),
      //   EditScreen.routeName: (_) => EditScreen(),
      //   CrashScreen.routeName: (_) => const CrashScreen(),
      // },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
            builder: (ctx) => const HomeScreen(), settings: settings);
      },
    );
  }
}
