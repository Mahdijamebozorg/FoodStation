import 'package:FoodApp/Providers/Settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/meal_item.dart';
import '../models/meal.dart';

class CategoryMealsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("Meals updated");
    //routes
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final categoryTitle = routeArgs['title'];
    final categoryId = routeArgs['id'];

    var settings = Provider.of<Settings>(context, listen: true);
    var islandscape = settings.islandscape(context);

    List<Meal> categoryMeals = settings.availableMeals.where((meal) {
      return meal.categories.contains(categoryId);
    }).toList();

    return Scaffold(
        appBar: AppBar(
          title: Text(categoryTitle!),
        ),
        body: Consumer<Settings>(
          builder: (_, settings, child) => GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: islandscape
                  ? settings.screenSize(context).width / 2
                  : settings.screenSize(context).height / 1,
              childAspectRatio: islandscape ? 7 / 5 : 1,
              mainAxisSpacing: settings.screenSize(context).height * 0.03,
              crossAxisSpacing: settings.screenSize(context).width * 0.01,
            ),
            itemBuilder: (ctx, index) {
              return MealItem(
                meal: categoryMeals[index],
              );
            },
            itemCount: categoryMeals.length,
          ),
        ));
  }
}
