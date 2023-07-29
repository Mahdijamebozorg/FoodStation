import 'package:food_app/View/screens/food_screen.dart';
import 'package:food_app/View/screens/setting_screen.dart';
import 'package:food_app/View/screens/home_screen.dart';
import 'package:food_app/View/widgets/Favorite_meal.dart';
import 'package:get/get.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(name: '/home', page: () => const HomeScreen()),
    GetPage(name: Favoritemeal.routeName, page: () => const Favoritemeal()),
    GetPage(name: FoodScreen.routeName, page: () => const FoodScreen()),
    GetPage(name: SettingScreeen.routeName, page: () => const SettingScreeen())
  ];
}
