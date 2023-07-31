// ignore_for_file: prefer_final_fields

import 'package:food_app/Model/food.dart';
import 'package:flutter/material.dart';

import 'package:food_app/Model/category.dart';
import 'package:food_app/Helpers/dummy_data.dart';
import 'package:food_app/Model/ingridient.dart';
import 'package:get/get.dart';

class Settings extends GetxController {
  RxMap<String, bool> _filters = RxMap();
  RxList<Category> _availableCategories = RxList();
  RxList<Food> _availablefoods = RxList();
  RxList<Food> _favoritefoods = RxList();
  RxList<Ingridient> _availableIngridient = RxList();

  Settings() {
    _availableCategories.value = dummyCats;
    _availablefoods.value = dummyfoods;
    _availableIngridient.value = dummyIngs;

    _filters = {
      'isGlutenFree': false,
      'isVegan': false,
      'isLactoseFree': false,
    }.obs;
  }

  //____________________________________________________________________________filters

  // TODO filters should be a list of hashtags.

  RxMap<String, bool> get filters {
    var copy = _filters;
    return copy;
  }

  void setfilters(Map<String, bool> filterdata, BuildContext context) {
    //set filters from input
    _filters.value = filterdata;

    //set available foods according to filters
    var newAvailablefoods = dummyfoods.where((element) {
      if (_filters['isGlutenFree']! && !element.isGlutenFree) {
        return false;
      } else if (_filters['isVegan']! && !element.isVegan) {
        return false;
      } else if (_filters['isLactoseFree']! && !element.isLactoseFree) {
        return false;
      } else {
        return true;
      }
    }).toList();

    setAvailablefoods(newAvailablefoods);
    update(["filters"]);
  }

  //_______________________________________________________________________________ available foods
  RxList<Food> get availablefoods {
    var copy = _availablefoods;
    return copy;
  }

  RxList<Food> getCategoryfoods(String catId) {
    return _availablefoods
        .where((food) {
          return food.categories.contains(catId);
        })
        .toList()
        .obs;
  }

  void setAvailablefoods(List<Food> newList) {
    _availablefoods.value = newList;
    update(["foods"]);
  }

  void addFood(Food food) {
    _availablefoods.add(food);
    update(["foods"]);
  }

  void removeFood({required String id}) {
    try {
      _availablefoods.removeWhere((food) => food.id == id);
      update(["foods"]);
    } catch (excp) {
      debugPrint("food $id not found");
    }
  }

  void updateFood({required String id, required Food newfood}) {
    final index = _availablefoods.indexWhere((food) => food.id == id);
    // if not found
    if (index == -1) {
      debugPrint("food $id not found");
      return;
    }
    _availablefoods[index] = newfood;
    update(["foods"]);
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

  //_______________________________________________________________________________ available categories
  RxList<Ingridient> get availableIngridient {
    var copy = _availableIngridient;
    return copy;
  }

  void setAvailableIngridient(List<Ingridient> newList) {
    _availableIngridient.value = newList;
    update(["ings"]);
  }

  //_______________________________________________________________________________ favorites
  List<Food> get favoritefoods {
    return _favoritefoods;
  }

  bool isFavorite(Food food) {
    return _favoritefoods.contains(food);
  }

  void addFavoriteFood(Food food) {
    _favoritefoods.add(food);
    update(["favs"]);
  }

  void removeFavoriteFood(Food food) {
    _favoritefoods.remove(food);
    update(["favs"]);
  }

  void toggleFav(Food food) {
    if (_favoritefoods.contains(food)) {
      removeFavoriteFood(food);
      Get.closeCurrentSnackbar();
      Get.showSnackbar(
        GetSnackBar(
          duration: const Duration(seconds: 3),
          title: "Removed from favorites: ",
          message: food.title,
        ),
      );
    } else {
      addFavoriteFood(food);
      Get.closeCurrentSnackbar();
      Get.showSnackbar(
        GetSnackBar(
          duration: const Duration(seconds: 3),
          title: "Added to favorites: ",
          message: food.title,
        ),
      );
    }
  }

  //_______________________________________________________________________________

  List<Food> simplefoodSearch({required String text, bool inFavs = false}) {
    return inFavs
        ? _favoritefoods
            .where(
                (food) => food.title.toLowerCase().contains(text.toLowerCase()))
            .toList()
        : _availablefoods
            .where(
                (food) => food.title.toLowerCase().contains(text.toLowerCase()))
            .toList();
  }

  List<Ingridient> ingridientSearch({required String text}) {
    return availableIngridient
        .where((ing) => ing.name.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }
}
