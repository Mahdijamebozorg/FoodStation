import 'package:food_app/View/screens/food_screen.dart';
import 'package:food_app/View/screens/setting_screen.dart';
import 'package:food_app/View/screens/tabs_screen.dart';
import 'package:food_app/View/widgets/Favorite_meal.dart';
import 'package:food_app/View/widgets/filters.dart';
import 'package:get/get.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(name: '/home', page: () => const TabsScreen()),
    GetPage(name: Favoritemeal.routeName, page: () => const Favoritemeal()),
    GetPage(name: FoodScreen.routeName, page: () => const FoodScreen()),
    GetPage(name: Filters.routeName, page: () => const Filters()),
    GetPage(name: SettingScreeen.routeName, page: () => const SettingScreeen())
  ];
}
