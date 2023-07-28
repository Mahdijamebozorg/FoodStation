import 'package:FoodApp/Model/category.dart';
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final Category catData;

  const CategoryItem(this.catData, {Key? key}) : super(key: key);

//use routes
  void selectCategory(BuildContext ctx) {
    Navigator.of(ctx).pushNamed(
      '/categoryMealsScreen',
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
          margin: const EdgeInsets.all(7),
          child: Center(
            child: Text(catData.title),
          ),
        ),
      ),
    );
  }
}
