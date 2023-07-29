import 'package:food_app/Model/meal.dart';
import 'package:flutter/material.dart';

import 'package:food_app/Model/category.dart';
import 'package:food_app/Helpers/dummy_data.dart';
import 'package:get/get.dart';

class Settings extends GetxController {
  RxMap<String, bool> _filters = RxMap();
  final RxList<Category> _availableCategories = RxList();
  final RxList<Meal> _availableMeals = RxList();
  final RxList<Meal> _favoriteMeals = RxList();

  Settings() {
    _availableCategories.value = dummyData;
    _availableMeals.value = dummyMeals;
    _filters = {
      'isGlutenFree': false,
      'isVegan': false,
      'isVegetarian': false,
      'isLactoseFree': false,
    }.obs;
  }

  //____________________________________________________________________________filters
  RxMap<String, bool> get filters {
    var copy = _filters;
    return copy;
  }

  void setfilters(Map<String, bool> filterdata, BuildContext context) {
    //set filters from input
    _filters.value = filterdata;

    //set available meals according to filters
    var newAvailableMeals = dummyMeals.where((element) {
      if (_filters['isGlutenFree']! && !element.isGlutenFree) {
        return false;
      } else if (_filters['isVegan']! && !element.isVegan) {
        return false;
      } else if (_filters['isVegetarian']! && !element.isVegetarian) {
        return false;
      } else if (_filters['isLactoseFree']! && !element.isLactoseFree) {
        return false;
      } else {
        return true;
      }
    }).toList();

    setAvailableMeals(newAvailableMeals);
    update(["filters"]);
  }

  //_______________________________________________________________________________ available meals
  RxList<Meal> get availableMeals {
    var copy = _availableMeals;
    return copy;
  }

  RxList<Meal> getCategorymeals(String catId) {
    return _availableMeals
        .where((meal) {
          return meal.categories.contains(catId);
        })
        .toList()
        .obs;
  }

  void setAvailableMeals(List<Meal> newList) {
    _availableMeals.value = newList;
    update(["meals"]);
  }

  //_______________________________________________________________________________ available categories
  RxList<Category> get availableCategories {
    var copy = _availableCategories;
    return copy;
  }

  void setAvailableCategories(List<Category> newList) {
    _availableCategories.value = newList;
    update(["cats"]);
  }

  //____________________________________________________ favorites
  RxList<Meal> get favoriteMeals {
    var copy = _favoriteMeals;
    return copy;
  }

  bool isFavorite(Meal meal) {
    return _favoriteMeals.contains(meal);
  }

  void addFavoriteMeal(Meal meal) {
    _favoriteMeals.add(meal);
    update(["favs"]);
  }

  void removeFavoriteMeal(Meal meal) {
    _favoriteMeals.remove(meal);
    update(["favs"]);
  }

  void toggleFav(Meal meal) {
    if (_favoriteMeals.contains(meal)) {
      removeFavoriteMeal(meal);
      Get.closeCurrentSnackbar();
      Get.showSnackbar(
        GetSnackBar(
          duration: const Duration(seconds: 3),
          title: "Removed from favorites: ",
          message: meal.title,
        ),
      );
    } else {
      addFavoriteMeal(meal);
      Get.closeCurrentSnackbar();
      Get.showSnackbar(
        GetSnackBar(
          duration: const Duration(seconds: 3),
          title: "Added to favorites: ",
          message: meal.title,
        ),
      );
    }
  }

  //___________________________________________________

  List<Meal> simpleMealSearch({required String text, bool inFavs = false}) {
    return inFavs
        ? _favoriteMeals
            .where(
                (meal) => meal.title.toLowerCase().contains(text.toLowerCase()))
            .toList()
        : _availableMeals
            .where(
                (meal) => meal.title.toLowerCase().contains(text.toLowerCase()))
            .toList();
  }
}
