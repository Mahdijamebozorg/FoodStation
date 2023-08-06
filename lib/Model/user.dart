enum Gender { male, female, notSet }

class User {
  final String id;
  final String name;
  Gender gender;
  double weight;
  double height;
  User(
    this.id,
    this.name,
    this.gender,
    this.weight,
    this.height,
  );

  static User dummy() {
    return User("uid123", "Mahdi", Gender.male, 78, 184);
  }
}