import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/Constants/app_colors.dart';
import 'package:food_app/gen/assets.gen.dart';
import 'package:get/get.dart';

enum LoginState {
  phone,
  signin,
  forgotSmsVld,
  resetPwd,
  signupSmsVld,
  signup,
}

class AuthController extends GetxController {
  final RxBool isAuth = false.obs;
  final RxString phoneNumber = "".obs;
  final RxString password = "".obs;
  final RxString token = "".obs;
  final RxString code = "".obs;
  final RxString name = "".obs;
  final RxString resetPwd = "".obs;
  final Rx<String?> surname = null.obs;
  final Rx<LoginState> step = LoginState.resetPwd.obs;
  final Rx<Response> response = const Response().obs;
  final RxBool loading = false.obs;
  final RxBool sex = false.obs; // false = woman, true = man

  // error msg for forms
  void showErrorSnackBar(String msg) {
    Get.closeCurrentSnackbar();
    Get.showSnackbar(GetSnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor: SolidColors.bg,
      titleText: Container(),
      messageText: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(msg, style: Get.theme.textTheme.bodySmall),
          const SizedBox(width: 8),
          SvgPicture.asset(Assets.images.triangleExclamationSolid),
        ],
      ),
    ));
  }

  Future checkNumber() async {
    await Future.delayed(const Duration(seconds: 1));
    return "has account";
  }

  Future sendSmsValidation() async {
    await Future.delayed(const Duration(seconds: 1));
    code.value = "response";
  }

  Future sendresetPwdValidation() async {
    await Future.delayed(const Duration(seconds: 1));
    code.value = "response";
  }

  Future signin() async {
    await Future.delayed(const Duration(seconds: 1));
    if (true) {
      isAuth.value = true;
      update(["isAuth"]);
    }
  }

  Future signup() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  bool checkCode(String value) {
    return code.value == value;
  }

  Future changePassword() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}
