import 'package:food_app/Model/food.dart';

class User {
  final String id;
  String name;
  String gender;
  final String phone;
  String username;
  final DateTime createdAt;
  DateTime updatedAt;
  List<Food> favoriteFoods;
  List<String> favoriteCategories;
  // double weight;
  // double height;
  User({
    required this.id,
    required this.name,
    required this.gender,
    required this.phone,
    required this.username,
    required this.createdAt,
    required this.updatedAt,
    this.favoriteFoods = const [],
    this.favoriteCategories = const [],
  }
      // this.weight,
      // this.height,
      );

  factory User.fromJson(Map<dynamic, dynamic> data) {
    return User(
        name: data['data']['user']['name'].toString(),
        id: data['data']['user']['id'].toString(),
        phone: data['data']['user']['phone'].toString(),
        username: data['data']['user']['username'].toString(),
        gender: data['data']['user']['gender'].toString(),
        createdAt:
            DateTime.parse(data['data']['user']['created_at'].toString()),
        updatedAt:
            DateTime.parse(data['data']['user']['updated_at'].toString()));
  }
}
