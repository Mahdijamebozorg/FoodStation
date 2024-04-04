import 'package:food_app/Controller/food_controller.dart';
import 'package:food_app/Model/food.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FoodItem extends StatelessWidget {
  final String foodId;

  const FoodItem({Key? key, required this.foodId}) : super(key: key);

//move inf to foodScreen
  void selectFood(BuildContext ctx) {
    Get.toNamed(
      '/foodScreen',
      arguments: {"foodId": foodId},
    );
  }

  @override
  Widget build(BuildContext context) {
    final Food food = Get.find<FoodController>().getFood(foodId)!;
    return LayoutBuilder(
      builder: (ctx, boxConstraints) => InkWell(
        onTap: () => selectFood(context),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          child: Column(
            children: [
              // image
              Avatar(food: food, boxConstraints: boxConstraints),
              // under Image
              Footage(food: food, boxConstraints: boxConstraints),
            ],
          ),
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  const Avatar({Key? key, required this.food, required this.boxConstraints})
      : super(key: key);

  final Food food;
  final BoxConstraints boxConstraints;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        //Image shape
        Hero(
          tag: food.id,
          child: SizedBox(
            width: boxConstraints.maxWidth * 1,
            height: boxConstraints.maxHeight * 0.88,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              // TODO: replace with these when data API is ready
              //Image
              // child: CachedNetworkImage(
              //   height: boxConstraints.maxHeight * 1,
              //   width: double.infinity,
              //   imageUrl: food.imageUrl,
              //   imageBuilder: (context, imageProvider) => Container(
              //     decoration: BoxDecoration(
              //       image: DecorationImage(image: imageProvider),
              //     ),
              //   ),
              //   placeholder: (context, url) =>
              //       const SpinKitFoldingCube(color: SolidColors.primary),
              //   errorWidget: (context, url, error) => const Icon(
              //     Icons.image_not_supported_outlined,
              //     color: Colors.grey,
              //   ),
              // ),
              child: Image.asset(
                food.imageUrl,
                fit: BoxFit.fill,
                height: boxConstraints.maxHeight,
                width: boxConstraints.maxWidth,
              ),
            ),
          ),
        ),
        //Text on Image
        Positioned(
          bottom: 15,
          right: 10,
          child: Container(
            decoration: const BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            padding: const EdgeInsets.all(8.0),
            width: boxConstraints.maxWidth * 0.6,
            child: Text(
              food.title,
              style: TextStyle(
                fontSize: boxConstraints.maxHeight * 0.08,
                color: Colors.white70,
              ),
              softWrap: true,
              overflow: TextOverflow.fade,
            ),
          ),
        )
      ],
    );
  }
}

class Footage extends StatelessWidget {
  const Footage({Key? key, required this.food, required this.boxConstraints})
      : super(key: key);

  final BoxConstraints boxConstraints;
  final Food food;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //Duration
            FittedBox(
              child: Row(
                children: [
                  const Icon(
                    Icons.schedule,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  Text('${food.duration} min'),
                ],
              ),
            ),
            //Complexity
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Row(
                children: [
                  const Icon(
                    Icons.square_foot_outlined,
                  ),
                  Text(food.complexityText),
                ],
              ),
            ),
            //Price
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  const Icon(
                    Icons.monetization_on_outlined,
                  ),
                  Text(food.affordabilityText),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
