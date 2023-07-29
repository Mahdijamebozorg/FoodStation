import 'package:food_app/Controller/settings.dart';
import 'package:food_app/View/widgets/food_item.dart';
import 'package:food_app/Model/meal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Favoritemeal extends StatelessWidget {
  static const routeName = "/FavoriteMeals";
  const Favoritemeal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final islandscape = mediaQuery.orientation == Orientation.landscape;
    final screenheigh = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    RxList<Meal> favoritemeal = Get.find<Settings>().favoriteMeals;
    return GridView.builder(
      //gridview options
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: islandscape ? screenwidth / 2 : screenheigh / 1,
        childAspectRatio: islandscape ? 7 / 5 : 1,
        mainAxisSpacing: screenheigh * 0.03,
        crossAxisSpacing: screenwidth * 0.01,
      ),
      //items
      itemBuilder: (ctx, index) => FoodItem(meal: favoritemeal[index]),
      itemCount: favoritemeal.length,
    );
  }
}
