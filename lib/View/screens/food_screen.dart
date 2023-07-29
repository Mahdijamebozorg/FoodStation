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
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    final Meal meal = routeArgs["meal"];

    ///body
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              elevation: 20,
              bottom: AppBar(
                leading: const SizedBox(),
                elevation: 0,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                centerTitle: true,
                title: Text(meal.title,
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              actions: [LikeButton(meal: meal)],
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: meal.id,
                  child: Image.asset(meal.imageUrl, fit: BoxFit.fill),
                ),
              ),
              expandedHeight: screenSize.height > screenSize.width
                  ? screenSize.height * 0.5
                  : screenSize.height,
              centerTitle: true,
              pinned: false,
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                IngridientsView(meal: meal),
                const SizedBox(height: 50.0),
                StepsView(meal: meal),
              ]),
            ),
          ],
        ),
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
              'Ingridients:',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          width: double.infinity,
          height: screenSize.height * 0.06,
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

class LikeButton extends StatefulWidget {
  final Meal meal;
  const LikeButton({required this.meal, Key? key}) : super(key: key);

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 200),
    vsync: this,
    value: 1.0,
  );

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<Settings>(
      id: "favs",
      builder: (Settings settings) => GestureDetector(
        onTap: () {
          settings.toggleFav(widget.meal);
          _controller.reverse().then((value) => _controller.forward());
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ScaleTransition(
            scale: Tween(begin: 0.7, end: 1.0).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeOut),
            ),
            child: settings.isFavorite(widget.meal)
                ? const Icon(
                    Icons.favorite,
                    size: 30,
                    color: Colors.red,
                  )
                : const Icon(
                    Icons.favorite_border,
                    size: 30,
                  ),
          ),
        ),
      ),
    );
  }
}
