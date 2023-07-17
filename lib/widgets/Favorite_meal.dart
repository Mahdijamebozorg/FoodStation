import 'package:FoodApp/Providers/Settings.dart';
import 'package:FoodApp/models/meal.dart';
import 'package:FoodApp/widgets/meal_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Favoritemeal extends StatefulWidget {
  @override
  _FavoritemealState createState() => _FavoritemealState();
}

class _FavoritemealState extends State<Favoritemeal> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final islandscape = mediaQuery.orientation == Orientation.landscape;
    final screenheigh = MediaQuery.of(context).size.height;
    final screenwidth = MediaQuery.of(context).size.width;
    List<Meal> favoritemeal =
        Provider.of<Settings>(context, listen: true).favoriteMeals;
    return GridView.builder(
      //gridview options
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: islandscape ? screenwidth / 2 : screenheigh / 1,
        childAspectRatio: islandscape ? 7 / 5 : 1,
        mainAxisSpacing: screenheigh * 0.03,
        crossAxisSpacing: screenwidth * 0.01,
      ),
      //items
      itemBuilder: (ctx, index) => MealItem(meal: favoritemeal[index]),
      itemCount: favoritemeal.length,
    );
  }
}
