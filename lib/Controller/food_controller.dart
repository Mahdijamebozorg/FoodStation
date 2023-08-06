import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:food_app/Controller/user_controller.dart';
import 'package:food_app/Helpers/dummy_data.dart';
import 'package:food_app/Model/food.dart';
import 'package:food_app/Model/ingredient.dart';

class FoodController extends GetxController {
  FoodController() {
    availableCategories.value = dummyCats;
    availableFoods.value = dummyfoods;
    availableIngredient.value = dummyIngs;
  }

  final RxList<String> availableCategories = RxList();
  final RxList<Food> availableFoods = RxList();
  final RxList<Ingredient> availableIngredient = RxList();

  @override
  void onInit() {
    // listen to filters
    ever(Get.find<UserController>().filters, (Map<String, bool>? filters) {
      if (filters == null) {
        throw ("No user controller set!");
      }
      //set available foods according to filters
      var newAvailablefoods = dummyfoods.where((element) {
        if (filters['isGlutenFree']! && !element.isGlutenFree) {
          return false;
        } else if (filters['isVegan']! && !element.isVegan) {
          return false;
        } else if (filters['isLactoseFree']! && !element.isLactoseFree) {
          return false;
        } else {
          return true;
        }
      }).toList();

      setAvailablefoods(newAvailablefoods);
      debugPrint("filters changed to: $filters");
    });

    super.onInit();
  }

  //_______________________________________________________________________________ availablefoodCtrl
  Food? getFood(String id) {
    try {
      return availableFoods.firstWhere((food) => food.id == id);
    } catch (excp) {
      debugPrint("food $id not found");
      return null;
    }
  }

  List<Food> getCategoryfoods(String catId) {
    return availableFoods.where((food) {
      return food.categories.contains(catId);
    }).toList();
  }

  void setAvailablefoods(List<Food> newList) {
    availableFoods.value = newList;
    debugPrint("foods setted");
    update(["foods"]);
  }

  void addFood(Food food) {
    availableFoods.add(food);
    debugPrint("food added");
    update(["foods"]);
  }

  void removeFood({required String id}) {
    try {
      availableFoods.removeWhere((food) => food.id == id);
      debugPrint("food removed");
      update(["foods"]);
    } catch (excp) {
      debugPrint("food $id not found");
    }
  }

  void updateFood({required String id, required Food newfood}) {
    final index = availableFoods.indexWhere((food) => food.id == id);
    // if not found
    if (index == -1) {
      debugPrint("food $id not found");
      return;
    }
    availableFoods[index] = newfood;
    debugPrint("food updated");
    update(["foods"]);
  }

  updateFoodAttribures() {}

  //_______________________________________________________________________________ available categories
  void setAvailableCategories(List<String> newList) {
    availableCategories.value = newList;
    debugPrint("cats updated");
    update(["cats"]);
  }

  //_______________________________________________________________________________ available ings
  List<String> get availableIngredientNames {
    List<String> names = [];
    for (var ing in availableIngredient) {
      names.add(ing.name);
    }
    return names;
  }

  void setAvailableIngredient(List<Ingredient> newList) {
    availableIngredient.value = newList;
    debugPrint("ings updated");
    update(["ings"]);
  }

  List<Food> simplefoodSearch({required String text, bool inFavs = false}) {
    return inFavs
        ? availableFoods
            .where((food) =>
                Get.find<UserController>().isFavorite(food) &&
                food.title.toLowerCase().contains(text.toLowerCase()))
            .toList()
        : availableFoods
            .where(
                (food) => food.title.toLowerCase().contains(text.toLowerCase()))
            .toList();
  }

  List<String> ingredientSearch({required String text}) {
    return availableIngredientNames
        .where((ing) => ing.toLowerCase().contains(text.toLowerCase()))
        .toList();
  }
}
