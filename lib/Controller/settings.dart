// ignore_for_file: prefer_final_fields

import 'package:food_app/Model/food.dart';
import 'package:flutter/material.dart';

import 'package:food_app/Helpers/dummy_data.dart';
import 'package:food_app/Model/ingridient.dart';
import 'package:get/get.dart';

class Settings extends GetxController {
  RxMap<String, bool> _filters = RxMap();
  RxList<String> _availableCategories = RxList();
  RxList<Food> _availablefoods = RxList();
  RxList<String> _favoritefoods = RxList();
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

  Map<String, bool> get filters {
    return {..._filters};
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
    debugPrint("filters updated");
    update(["filters"]);
  }

  //_______________________________________________________________________________ available foods
  Food? getFood(String id) {
    try {
      return _availablefoods.firstWhere((food) => food.id == id);
    } catch (excp) {
      debugPrint("food $id not found");
      return null;
    }
  }

  List<Food> get availablefoods {
    return [..._availablefoods];
  }

  List<Food> getCategoryfoods(String catId) {
    return _availablefoods.where((food) {
      return food.categories.contains(catId);
    }).toList();
  }

  void setAvailablefoods(List<Food> newList) {
    _availablefoods.value = newList;
    debugPrint("foods setted");
    update(["foods"]);
  }

  void addFood(Food food) {
    _availablefoods.add(food);
    debugPrint("food added");
    update(["foods"]);
  }

  void removeFood({required String id}) {
    try {
      _availablefoods.removeWhere((food) => food.id == id);
      debugPrint("food removed");
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
    debugPrint("food updated");
    update(["foods"]);
  }

  updateFoodAttribures() {}

  //_______________________________________________________________________________ available categories
  List<String> get availableCategories {
    return [..._availableCategories];
  }

  void setAvailableCategories(List<String> newList) {
    _availableCategories.value = newList;
    debugPrint("cats updated");
    update(["cats"]);
  }

  //_______________________________________________________________________________ available categories
  List<Ingridient> get availableIngridient {
    return [..._availableIngridient];
  }

  List<String> get availableIngridientNames {
    List<String> names = [];
    for (var ing in _availableIngridient) {
      names.add(ing.name);
    }
    return names;
  }

  void setAvailableIngridient(List<Ingridient> newList) {
    _availableIngridient.value = newList;
    debugPrint("ings updated");
    update(["ings"]);
  }

  //_______________________________________________________________________________ favorites
  List<String> get favoritefoods {
    return _favoritefoods;
  }

  bool isFavorite(Food food) {
    return _favoritefoods.contains(food.id);
  }

  void addFavoriteFood(String id) {
    _favoritefoods.add(id);
    debugPrint("favs updated");
    update(["favs"]);
  }

  void removeFavoriteFood(String id) {
    _favoritefoods.remove(id);
    debugPrint("favs updated");
    update(["favs"]);
  }

  void toggleFav(String id) {
    if (_favoritefoods.contains(id)) {
      removeFavoriteFood(id);
      Get.closeCurrentSnackbar();
      Get.showSnackbar(
        GetSnackBar(
          duration: const Duration(seconds: 3),
          title: "Removed from favorites: ",
          message: getFood(id)!.title,
        ),
      );
    } else {
      addFavoriteFood(id);
      Get.closeCurrentSnackbar();
      Get.showSnackbar(
        GetSnackBar(
          duration: const Duration(seconds: 3),
          title: "Added to favorites: ",
          message: getFood(id)!.title,
        ),
      );
    }
  }

  //_______________________________________________________________________________

  List<Food> simplefoodSearch({required String text, bool inFavs = false}) {
    return inFavs
        ? _availablefoods
            .where((food) =>
                isFavorite(food) &&
                food.title.toLowerCase().contains(text.toLowerCase()))
            .toList()
        : _availablefoods
            .where(
                (food) => food.title.toLowerCase().contains(text.toLowerCase()))
            .toList();
  }

  List<String> ingridientSearch({required String text}) {
    return availableIngridientNames
        .where((ing) => ing.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }
}
