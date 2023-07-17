import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealItem extends StatelessWidget {
  final Meal meal;

  MealItem({
    required this.meal,
  });

  String get complexityText {
    if (meal.complexity == Complexity.Simple) {
      return 'simple';
    }
    if (meal.complexity == Complexity.Challenging) {
      return 'Challenging';
    }
    if (meal.complexity == Complexity.Hard) {
      return 'Hard';
    } else
      return 'Unknown';
  }

  String get affordabilityText {
    switch (meal.affordability) {
      case Affordability.Affordable:
        return 'Affordable';
        break;
      case Affordability.Pricey:
        return 'Pricey';
        break;
      case Affordability.Luxurious:
        return 'Expensive';
        break;
      default:
        return 'Unknown';
    }
  }

//move inf to mealscreen
  void selectmeal(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      'mealscreen',
      arguments: {'Meal': meal},
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
                  Container(
                    width: size.maxWidth * 1,
                    height: size.maxHeight * 0.83,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
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
                    padding: EdgeInsets.all(5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        //Duration
                        Container(
                          margin: EdgeInsets.all(5),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.schedule,
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text('${meal.duration} min'),
                            ],
                          ),
                        ),
                        //Complexity
                        Container(
                          margin: EdgeInsets.all(5),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.square_foot_outlined,
                              ),
                              Text(complexityText),
                            ],
                          ),
                        ),
                        //Price
                        Container(
                          margin: EdgeInsets.all(5),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.monetization_on_outlined,
                              ),
                              Text(affordabilityText),
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
