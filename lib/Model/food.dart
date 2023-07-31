import 'dart:math';

enum Complexity { simple, challenging, hard }

enum Affordability { affordable, pricey, luxurious }

class Food {
  final String id;
  final String title;
  final int duration;
  final String imageUrl;
  final Complexity complexity;
  final Affordability affordability;
  final List<String> steps;
  final List<String> ingredients;
  final List<String> categories;
  final bool isGlutenFree;
  final bool isLactoseFree;
  final bool isVegan;

  const Food({
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
    );
  }

  static Food updateFood({
    required Food food,
    String? id,
    String? title,
    String? imageUrl,
    int? duration,
    Affordability? affordability,
    Complexity? complexity,
    List<String>? categories,
    List<String>? ingredients,
    List<String>? steps,
    bool? isGlutenFree,
    bool? isLactoseFree,
    bool? isVegan,
  }) {
    id = id ?? food.id;
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
      id: id,
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
    );
  }
}
