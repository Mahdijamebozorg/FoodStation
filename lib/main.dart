import 'package:food_app/Controller/settings.dart';
import 'package:food_app/Theme/app_theme.dart';
import 'package:food_app/View/screens/food_screen.dart';
import 'package:food_app/View/screens/setting_screen.dart';
import 'package:food_app/View/screens/home_screen.dart';
import 'package:food_app/View/screens/category_screen.dart';
import 'package:food_app/View/widgets/Favorite_meal.dart';
import 'package:food_app/View/widgets/filters.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // put dependecies
  Get.put(Settings());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Food App',
      theme: appTheme(),
      // getPages: AppPages.pages,
      // initialBinding: MainBinding(),
      initialRoute: '/home',
      routes: {
        '/home': (_) => const HomeScreen(),
        CategoryScreen.routeName: (_) => const CategoryScreen(),
        Favoritemeal.routeName: (_) => const Favoritemeal(),
        FoodScreen.routeName: (_) => const FoodScreen(),
        SettingScreeen.routeName: (_) => const SettingScreeen()
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
            builder: (ctx) => const HomeScreen(), settings: settings);
      },
    );
  }
}
