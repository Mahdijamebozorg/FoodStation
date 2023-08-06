import 'dart:math';

enum Complexity { simple, challenging, hard }

enum Affordability { affordable, pricey, luxurious }

enum Unit {
  // solids
  tableSpoon,
  teaSpoon,
  sheets,
  piece,
  grams,
  // liquids
  bottle,
  litre,
  miliLitre,
}

class Quantity {
  Unit unit;
  double count;
  Quantity(this.unit, this.count);
}

class Food {
  final String id;
  String title;
  int duration;
  String imageUrl;
  Complexity complexity;
  Affordability affordability; // cost
  List<String> steps;
  List<Map<String, Quantity?>> ingredients;
  List<String> categories;
  bool isGlutenFree;
  bool isLactoseFree;
  bool isVegan;
  String userId;

  Food({
    required this.id,
    required this.categories,
    required this.title,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
    required this.duration,
    required this.complexity,
    required this.affordability,
    required this.isGlutenFree,
    required this.isLactoseFree,
    required this.isVegan,
    required this.userId,
  });

  String get complexityText {
    switch (complexity) {
      case Complexity.simple:
        return 'Simple';
      case Complexity.challenging:
        return 'Challenging';
      case Complexity.hard:
        return 'Hard';
      default:
        return 'Unknown';
    }
  }

  String get affordabilityText {
    switch (affordability) {
      case Affordability.affordable:
        return 'Affordable';
      case Affordability.pricey:
        return 'Pricey';
      case Affordability.luxurious:
        return 'Expensive';
      default:
        return 'Unknown';
    }
  }

  List<String> get getIngredientsNames {
    List<String> ings = [];
    for (var ing in ingredients) {
      ings.add(ing.keys.first);
    }
    return ings;
  }

  List<String> get getAllIngredientsNames {
    List<String> ings = [];
    for (var ing in ingredients) {
      ings.add(ing.keys.first);
    }
    return ings;
  }

  static Food get dummy {
    return Food(
        // TODO id generation must be from api
        id: Random().nextInt(1000).toString(),
        categories: [],
        title: "",
        affordability: Affordability.affordable,
        complexity: Complexity.simple,
        imageUrl: "",
        duration: 0,
        ingredients: [],
        steps: [],
        isGlutenFree: false,
        isVegan: false,
        isLactoseFree: false,
        userId: "");
  }

  static Food editFood({
    required Food food,
    String? title,
    String? imageUrl,
    int? duration,
    Affordability? affordability,
    Complexity? complexity,
    List<String>? categories,
    List<Map<String, Quantity?>>? ingredients,
    List<Map<String, Quantity?>>? optionalIngredients,
    List<String>? steps,
    bool? isGlutenFree,
    bool? isLactoseFree,
    bool? isVegan,
  }) {
    title = title ?? food.title;
    imageUrl = imageUrl ?? food.imageUrl;
    duration = duration ?? food.duration;
    affordability = affordability ?? food.affordability;
    complexity = complexity ?? food.complexity;
    categories = categories ?? food.categories;
    ingredients = ingredients ?? food.ingredients;
    steps = steps ?? food.steps;
    isGlutenFree = isGlutenFree ?? food.isGlutenFree;
    isLactoseFree = isLactoseFree ?? food.isLactoseFree;
    isVegan = isVegan ?? food.isVegan;

    return Food(
      id: food.id,
      categories: categories,
      title: title,
      imageUrl: imageUrl,
      ingredients: ingredients,
      steps: steps,
      duration: duration,
      complexity: complexity,
      affordability: affordability,
      isGlutenFree: isGlutenFree,
      isLactoseFree: isLactoseFree,
      isVegan: isVegan,
      userId: food.userId,
    );
  }
}
