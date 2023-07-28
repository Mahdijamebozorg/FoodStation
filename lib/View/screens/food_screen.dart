import 'package:flutter/foundation.dart';
import 'package:food_app/Controller/settings.dart';
import 'package:flutter/material.dart';
import 'package:food_app/Model/meal.dart';
import 'package:get/get.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({Key? key}) : super(key: key);
  static const routeName = "/foodScreen";

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    // final bool islandscape =
    //     MediaQuery.of(context).orientation == Orientation.landscape;
    //routes
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    final Meal meal = routeArgs["meal"];

    ///body
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [FavButton(meal: meal)],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: meal.id,
                child: Image.asset(meal.imageUrl, fit: BoxFit.fill),
              ),
            ),
            expandedHeight: defaultTargetPlatform == TargetPlatform.android ||
                    defaultTargetPlatform == TargetPlatform.iOS
                ? screenSize.height * 0.5
                : screenSize.height,
            elevation: 20,
            centerTitle: true,
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              IngridientsView(meal: meal),
              StepsView(meal: meal),
            ]),
          ),
        ],
      ),
    );
  }
}

class StepsView extends StatelessWidget {
  const StepsView({
    Key? key,
    required this.meal,
  }) : super(key: key);

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);

    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Steps:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
        SizedBox(
          width: screenSize.width * 0.8,
          height: screenSize.height * 0.5,
          child: ListWheelScrollView(
            itemExtent: 150,
            children: List.generate(
              meal.steps.length,
              (index) => ListTile(
                leading: CircleAvatar(
                  child: Text('# ${index + 1}'),
                ),
                title: Text(meal.steps[index]),
                tileColor: Colors.purple[800],
                contentPadding: const EdgeInsets.all(8),
              ),
              //Divide listTile
            ),
          ),
        ),
      ],
    );
  }
}

class IngridientsView extends StatelessWidget {
  const IngridientsView({
    Key? key,
    required this.meal,
  }) : super(key: key);

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);

    return Column(
      children: [
        //ingridients
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'ingridients:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: screenSize.height * 0.07,
          child: ListView.builder(
            itemCount: meal.ingredients.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) => Container(
              decoration: const BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.all(2.0),
              child: Text(
                meal.ingredients[index],
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class FavButton extends StatelessWidget {
  const FavButton({
    Key? key,
    required this.meal,
  }) : super(key: key);

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Settings>(
      id: "favs",
      builder: (Settings settings) => IconButton(
          onPressed: () {
            if (settings.favoriteMeals.contains(meal)) {
              settings.removeFavoriteMeal(meal);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 1),
                  backgroundColor: Theme.of(context).primaryColor,
                  content: const Text(
                    "Removed from favorites",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            } else {
              settings.addFavoriteMeal(meal);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 1),
                  backgroundColor: Theme.of(context).primaryColor,
                  content: const Text(
                    "Added to favorites",
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
          },
          icon: Icon(
            Icons.star,
            color: settings.favoriteMeals.contains(meal)
                ? Colors.yellow
                : Colors.grey,
            size: 30,
          )),
    );
  }
}
