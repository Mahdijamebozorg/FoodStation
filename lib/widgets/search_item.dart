import 'package:FoodApp/models/meal.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SearchItem extends StatelessWidget {
  final Meal meal;
  final Function remove;
  SearchItem({required this.meal, required this.remove});

  void selectmeal(BuildContext ctx) {
    Navigator.of(ctx).pushNamed('mealscreen', arguments: {'Meal': meal});
  }

  @override
  Widget build(BuildContext context) {
    var screenheigh = MediaQuery.of(context).size.height;
    var screenwidth = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () => selectmeal(context),
      borderRadius: BorderRadius.circular(30),
      //for removing unwanted meals from search and comparing others
      child: Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        dragStartBehavior: DragStartBehavior.start,
        onDismissed: (DismissDirection dir) {
          remove(meal);
        },
        background: Container(
          color: Theme.of(context).primaryColor,
          alignment: Alignment.centerRight,
          child: Container(
            margin: EdgeInsets.all(8),
            child: Icon(
              Icons.delete,
              color: Theme.of(context).backgroundColor,
              size: MediaQuery.of(context).size.height * 0.075,
            ),
          ),
        ),
        child: Card(
          color: Theme.of(context).highlightColor,
          elevation: 7,
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(30))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              //image
              Container(
                height: screenheigh * 0.2,
                width: screenwidth * 0.2,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                  child: Image.asset(
                    meal.imageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                width: screenwidth * 0.08,
              ),
              //text
              Expanded(
                child: Text(
                  meal.title,
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height * 0.04),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
