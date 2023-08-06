import 'package:food_app/Controller/comment_controller.dart';
import 'package:food_app/Controller/food_controller.dart';
import 'package:food_app/Controller/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:food_app/Model/comment.dart';
import 'package:food_app/Model/food.dart';
import 'package:food_app/View/screens/edit_screen.dart';
import 'package:get/get.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({Key? key}) : super(key: key);
  static const routeName = "/foodScreen";

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final Size screenSize = MediaQuery.sizeOf(context);
    // final bool islandscape =
    //     MediaQuery.of(context).orientation == Orientation.landscape;
    final routeArgs = Get.arguments as Map?;
    final String? foodId = routeArgs == null ? null : routeArgs["foodId"];
    if (foodId == null) Get.offNamed("/crash");

    ///body
    return GetBuilder<FoodController>(
        id: "foods",
        builder: (foodCtrl) {
          final food = foodCtrl.getFood(foodId!);
          return SafeArea(
            child: Scaffold(
              key: scaffoldKey,
              body: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    elevation: 20,
                    bottom: AppBar(
                      leading: const SizedBox(),
                      elevation: 0,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      centerTitle: true,
                      title: Text(food!.title,
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                    actions: [
                      LikeButton(food: food),
                      IconButton(
                          onPressed: () => scaffoldKey.currentState!
                              .showBottomSheet(
                                  (context) => EditScreen(food: food)),
                          icon: const Icon(Icons.edit))
                    ],
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
                      IngredientsView(food: food),
                      const SizedBox(height: 50.0),
                      StepsView(food: food),
                      const SizedBox(height: 20.0),
                      CommentsList(food: food),
                    ]),
                  ),
                ],
              ),
            ),
          );
        });
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

class IngredientsView extends StatelessWidget {
  const IngredientsView({
    Key? key,
    required this.food,
  }) : super(key: key);

  final Food food;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);

    return Column(
      children: [
        //Ingredients
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              'Ingredients:',
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
                food.getIngredientsNames[index],
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
    return GetBuilder<UserController>(
      id: "favs",
      builder: (UserController userCtrl) => GestureDetector(
        onTap: () {
          userCtrl.toggleFav(widget.food.id);
          _controller.reverse().then((value) => _controller.forward());
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ScaleTransition(
            scale: Tween(begin: 0.7, end: 1.0).animate(
              CurvedAnimation(parent: _controller, curve: Curves.easeOut),
            ),
            child: userCtrl.isFavorite(widget.food)
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

class CommentsList extends StatelessWidget {
  final Food food;
  const CommentsList({required this.food, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textCtrl = TextEditingController();
    final Size screenSize = MediaQuery.sizeOf(context);
    final Comment cm = Comment.dummy();
    return GetBuilder<UserController>(
        id: "user",
        builder: (user) {
          return GetBuilder<CommentController>(
            id: "comments",
            builder: (comments) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                height: screenSize.height * 0.4,
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.topLeft,
                      child: Text("Comments"),
                    ),
                    TextField(
                      controller: textCtrl,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    TextButton.icon(
                        onPressed: () {
                          if (textCtrl.text.isNotEmpty) {
                            cm.foodId = food.id;
                            cm.userId =
                                Get.find<UserController>().user.value.id;
                            cm.message = textCtrl.text;
                            comments.addComment(cm);
                            textCtrl.clear();
                          }
                        },
                        icon: const Icon(Icons.add, color: Colors.black),
                        label: const Text("Add comment")),
                    Expanded(
                        child: ListView.builder(
                      itemCount: comments.getFoodComments(food.id).length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          subtitle: Text(
                            comments.getFoodComments(food.id)[index].message,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          title: Text(
                            user.user.value.name,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      },
                    )),
                  ],
                ),
              );
            },
          );
        });
  }
}
