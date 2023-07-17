import 'package:flutter/material.dart';

import 'package:FoodApp/models/category.dart';
import 'package:FoodApp/dummy_data.dart';
import 'package:FoodApp/models/meal.dart';

class Settings with ChangeNotifier {
  //____________________________________________________________________________filters
  static Map<String, bool> _filters = {
    'isGlutenFree': false,
    'isVegan': false,
    'isVegetarian': false,
    'isLactoseFree': false,
  };

  Map<String, bool> get filters {
    return {..._filters};
  }

  void setfilters(Map<String, bool> filterdata, BuildContext context) {
    //set filters from input
    _filters = filterdata;

    //set available meals according to filters
    var newAvailableMeals = DUMMY_MEALS.where((element) {
      if (_filters['isGlutenFree']! && !element.isGlutenFree) {
        return false;
      } else if (_filters['isVegan']! && !element.isVegan) {
        return false;
      } else if (_filters['isVegetarian']! && !element.isVegetarian) {
        return false;
      } else if (_filters['isLactoseFree']! && !element.isLactoseFree) {
        return false;
      } else
        return true;
    }).toList();

    setAvailableMeals(newAvailableMeals);
    notifyListeners();
  }

  //_______________________________________________________________________________ available meals
  static List<Meal> _availableMeals = DUMMY_MEALS;

  List<Meal> get availableMeals {
    return [..._availableMeals];
  }

  void setAvailableMeals(List<Meal> newList) {
    _availableMeals = newList;
    notifyListeners();
  }

  //_______________________________________________________________________________ available categories
  static List<Category> _availableCategories = DUMMY_CATEGORIES;

  List<Category> get availableCategories {
    return [..._availableCategories];
  }

  void setAvailableCategories(List<Category> newList) {
    _availableCategories = newList;
    notifyListeners();
  }

  //____________________________________________________ favorites
  static List<Meal> _favoriteMeals = [];

  List<Meal> get favoriteMeals {
    return [..._favoriteMeals];
  }

  void addFavoriteMeal(Meal meal) {
    _favoriteMeals.add(meal);
    notifyListeners();
  }

  void removeFavoriteMeal(Meal meal) {
    _favoriteMeals.remove(meal);
    notifyListeners();
  }

  //_______________________________________________________________________________ screen details
  bool islandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  Size screenSize(BuildContext context) {
    return MediaQuery.of(context).size;
  }
}
