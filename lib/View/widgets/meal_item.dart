import 'package:food_app/Model/meal.dart';
import 'package:flutter/material.dart';

class MealItem extends StatelessWidget {
  final Meal meal;

  const MealItem({Key? key, required this.meal}) : super(key: key);

//move inf to FoodScreen
  void selectmeal(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      '/foodScreen',
      arguments: {"meal": meal},
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, size) => InkWell(
        onTap: () => selectmeal(context),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  //Image shape
                  Hero(
                    tag: meal.id,
                    child: SizedBox(
                      width: size.maxWidth * 1,
                      height: size.maxHeight * 0.83,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        //Image
                        child: Image.asset(
                          meal.imageUrl,
                          height: size.maxHeight * 1,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  //Text postion on Image
                  Positioned(
                    bottom: 15,
                    right: 10,
                    //Text
                    child: Container(
                      width: size.maxWidth * 0.6,
                      color: Colors.black45,
                      child: Text(
                        meal.title,
                        style: TextStyle(
                          fontSize: size.maxHeight * 0.08,
                          color: Colors.white70,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  )
                ],
              ),
              //under Image
              Expanded(
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        //Duration
                        Container(
                          margin: const EdgeInsets.all(5),
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.schedule,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text('${meal.duration} min'),
                            ],
                          ),
                        ),
                        //Complexity
                        Container(
                          margin: const EdgeInsets.all(5),
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.square_foot_outlined,
                              ),
                              Text(meal.complexityText),
                            ],
                          ),
                        ),
                        //Price
                        Container(
                          margin: const EdgeInsets.all(5),
                          child: Row(
                            children: <Widget>[
                              const Icon(
                                Icons.monetization_on_outlined,
                              ),
                              Text(meal.affordabilityText),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
