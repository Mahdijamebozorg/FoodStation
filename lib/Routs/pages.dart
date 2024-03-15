import 'package:food_app/View/screens/edit_screen.dart';
import 'package:food_app/View/screens/category_screen.dart';
import 'package:food_app/View/screens/crash_screen.dart';
import 'package:food_app/View/screens/food_screen.dart';
import 'package:food_app/View/screens/login.dart';
import 'package:food_app/View/screens/setting_screen.dart';
import 'package:food_app/View/screens/home_screen.dart';
import 'package:get/get.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(name: HomeScreen.routeName, page: () => HomeScreen()),
    GetPage(name: LoginScreen.routeName, page: () => LoginScreen()),
    GetPage(name: FoodScreen.routeName, page: () => const FoodScreen()),
    GetPage(name: CategoryScreen.routeName, page: () => const CategoryScreen()),
    GetPage(name: SettingScreen.routeName, page: () => const SettingScreen()),
    GetPage(name: EditScreen.routeName, page: () => EditScreen()),
    GetPage(name: CrashScreen.routeName, page: () => const CrashScreen())
  ];
}
