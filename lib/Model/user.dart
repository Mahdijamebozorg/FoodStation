import 'package:food_app/Model/food.dart';

enum Gender { male, female, notSet }

class User {
  final String id;
  final String name;
  Gender gender;
  double weight;
  double height;
  List<Food> favoriteFoods;
  List<String> favoriteCategories;
  User(
    this.id,
    this.name,
    this.gender,
    this.weight,
    this.height,
    this.favoriteFoods,
    this.favoriteCategories,
  );

  static User dummy() {
    return User("uid123", "Mahdi", Gender.male, 78, 184, [], []);
  }
}
