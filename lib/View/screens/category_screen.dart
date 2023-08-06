import 'package:food_app/Controller/food_controller.dart';
import 'package:food_app/View/widgets/food_item.dart';
import 'package:flutter/material.dart';
import 'package:food_app/Model/food.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatelessWidget {
  static const routeName = "/categoryScreen";
  const CategoryScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //
    final args = Get.arguments as Map?;
    final String? category = args == null ? null : args["category"];

    if (category == null) Get.offNamed("/crash");

    var islandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final screenSize = MediaQuery.sizeOf(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(category!),
        ),
        body: GetBuilder<FoodController>(
            id: "foods",
            builder: (foodCtrl) {
              List<Food> categoryfoods =foodCtrl.getCategoryfoods(category);
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: islandscape
                      ? screenSize.width / 2
                      : screenSize.height / 1,
                  childAspectRatio: islandscape ? 7 / 5 : 1,
                  mainAxisSpacing: screenSize.height * 0.03,
                  crossAxisSpacing: screenSize.width * 0.01,
                ),
                itemCount: categoryfoods.length,
                itemBuilder: (ctx, index) {
                  return FoodItem(
                    foodId: categoryfoods[index].id,
                  );
                },
              );
            }),
      ),
    );
  }
}
