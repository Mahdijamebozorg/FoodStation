import 'package:FoodApp/models/category.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final Category catData;

  CategoryItem(this.catData);

//use routes
  void selectCategory(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      'CategoryMealsScreen',
      arguments: {
        'id': catData.id,
        'title': catData.title,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(29),
      // splashColor: color,
      onTap: () => selectCategory(context),
      child: Container(
        decoration: BoxDecoration(
          //////gradient color
          gradient: LinearGradient(
            colors: [catData.color.withOpacity(0.3), catData.color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          color: catData.color,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(29),
          ),
          elevation: 20,
          margin: EdgeInsets.all(7),
          child: Center(
            child: Text(catData.title),
          ),
        ),
      ),
    );
  }
}
