import 'dart:math';

class Comment {
  String id;
  String message;
  String userId;
  String foodId;
  Comment({
    required this.id,
    required this.message,
    required this.userId,
    required this.foodId,
  });

  static Comment dummy() {
    return Comment(
      id: Random().nextInt(1000).toString(),
      message: "",
      userId: "",
      foodId: "",
    );
  }
}
