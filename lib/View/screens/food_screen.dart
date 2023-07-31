import 'package:food_app/Controller/settings.dart';
import 'package:flutter/material.dart';
import 'package:food_app/Model/food.dart';
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
    final Food food = routeArgs["food"];

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
                title: Text(food.title,
                    style: Theme.of(context).textTheme.bodyMedium),
              ),
              actions: [LikeButton(food: food)],
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Hero(
                  tag: food.id,
                  child: Image.asset(food.imageUrl, fit: BoxFit.fill),
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
                IngridientsView(food: food),
                const SizedBox(height: 50.0),
                StepsView(food: food),
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
    required this.food,
  }) : super(key: key);

  final Food food;

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
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        SizedBox(
          width: screenSize.width * 0.8,
          height: screenSize.height * 0.5,
          child: ListWheelScrollView(
            itemExtent: 150,
            children: List.generate(
              food.steps.length,
              (index) => ListTile(
                leading: CircleAvatar(
                  child: Text('# ${index + 1}'),
                ),
                title: Text(food.steps[index]),
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
    required this.food,
  }) : super(key: key);

  final Food food;

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
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        SizedBox(
          width: double.infinity,
          height: screenSize.height * 0.06,
          child: ListView.builder(
            itemCount: food.ingredients.length,
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
                food.ingredients[index],
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
  final Food food;
  const LikeButton({required this.food, Key? key}) : super(key: key);

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
          settings.toggleFav(widget.food);
          _controller.reverse().then((value) => _controller.forward());
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ScaleTransition(
            scale: Tween(begin: 0.7, end: 1.0).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeOut),
            ),
            child: settings.isFavorite(widget.food)
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
