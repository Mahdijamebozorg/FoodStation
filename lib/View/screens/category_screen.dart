import 'package:food_app/Controller/settings.dart';
import 'package:food_app/View/widgets/food_item.dart';
import 'package:flutter/material.dart';
import 'package:food_app/Model/food.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  static const routeName = "/categoryScreen";
  const CategoryScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    debugPrint("foods updated");
    //routes
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final categoryTitle = routeArgs['title'];
    final categoryId = routeArgs['id'];

    Settings settings = Get.find<Settings>();
    var islandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    RxList<Food> categoryfoods = settings.getCategoryfoods(categoryId!);

    final screenSize = MediaQuery.sizeOf(context);

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(categoryTitle!),
          ),
          body: GridView.builder(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent:
                  islandscape ? screenSize.width / 2 : screenSize.height / 1,
              childAspectRatio: islandscape ? 7 / 5 : 1,
              mainAxisSpacing: screenSize.height * 0.03,
              crossAxisSpacing: screenSize.width * 0.01,
            ),
            itemBuilder: (ctx, index) {
              return FoodItem(
                food: categoryfoods[index],
              );
            },
            itemCount: categoryfoods.length,
          )),
    );
  }
}
