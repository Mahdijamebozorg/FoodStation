import 'package:food_app/Controller/food_controller.dart';
import 'package:food_app/Helpers/dummy_data.dart';
import 'package:food_app/Model/comment.dart';
import 'package:food_app/Model/food.dart';
import 'package:get/get.dart';

class CommentController extends GetxController {
  RxList<Comment> comments = dummyComments.obs;
  @override
  void onInit() {
    //   ever(Get.find<UserController>().currentUser, (callback) => null);
    ever(Get.find<FoodController>().availableFoods, (List<Food> foods) {
      List<Comment> toRemove = [];
      for (Comment comment in comments) {
        // if food removed
        if (!foods
            .contains(Get.find<FoodController>().getFood(comment.foodId))) {
          // remove later because of collision
          toRemove.add(comment);
        }
      }
      comments.removeWhere((comment) => toRemove.contains(comment));
    });
    super.onInit();
  }

  void addComment(Comment comment) {
    comments.add(comment);
    update(["comments"]);
  }

  List<Comment> getFoodComments(String foodId) {
    return comments.where((cm) => cm.foodId == foodId).toList();
  }
}
