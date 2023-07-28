import 'package:FoodApp/Controller/Settings.dart';
import 'package:get/get.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(Settings());
  }
}
