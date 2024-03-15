import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/Constants/api_consts.dart';
import 'package:food_app/Constants/app_colors.dart';
import 'package:food_app/Controller/user_controller.dart';
import 'package:food_app/Model/user.dart';
import 'package:food_app/Service/http_service.dart';
import 'package:food_app/gen/assets.gen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum LoginState {
  phone,
  signin,
  phoneVerification,
  signup,
  pwdReset,
  pwdResetVerification,
  pwdResetChange,
}

class AuthController extends GetxController {
  final RxBool isAuth = false.obs;
  final RxString phoneNumber = "".obs;
  final RxString password = "".obs;
  final RxString newPassword = "".obs;
  final RxString token = "".obs;
  final RxString code = "".obs;
  final RxString name = "".obs;
  final Rx<String> surname = "".obs;
  final Rx<LoginState> step = LoginState.phone.obs;
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
          Expanded(
            child: Text(
              msg,
              style: Get.theme.textTheme.bodySmall,
              softWrap: true,
            ),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(
            Assets.images.triangleExclamationSolid,
            height: 30,
            width: 30,
          ),
        ],
      ),
    ));
  }

  void saveForm(GlobalKey<FormState> form, {BuildContext? constext}) async {
    // validate and save
    if (!form.currentState!.validate()) return;
    form.currentState!.save();

    switch (step.value) {
      // -------------------------------------------------------- phone
      // TODO: specify the errors

      case LoginState.phone:
        {
          try {
            loading.value = true;
            final response = await checkPhone();
            loading.value = false;

            if (response == null) {
              showErrorSnackBar("مشکلی پیش آمده است");
            }
            // if has account
            else if (HttpService.cmpFirstLetter(
                code: response.statusCode!, num: 2)) {
              step.value = LoginState.signin;
              update(['step']);
            }
            // if not
            else if (HttpService.cmpFirstLetter(
                code: response.statusCode!, num: 4)) {
              loading.value = true;
              await registerPhone();
              loading.value = false;
              step.value = LoginState.phoneVerification;
              update(['step']);
            }
            // other cases
            else {
              showErrorSnackBar(response.toString());
            }
          } catch (error) {
            String message = error.toString();
            if (error is! dio.DioException) rethrow;

            if (error.type == dio.DioExceptionType.connectionError) {
              message = 'اتصال اینترنت را بررسی کنید';
            }
            // on 404 Error
            else if (error.type == dio.DioExceptionType.badResponse) {
              loading.value = true;
              await registerPhone();
              loading.value = false;
              step.value = LoginState.phoneVerification;
              update(['step']);
              message = 'OK';
            }
            showErrorSnackBar(message);
          }
          loading.value = false;
        }
        break;

      // -------------------------------------------------------- signin
      case LoginState.signin:
        {
          loading.value = true;

          try {
            final response = await signin();

            if (response == null) {
              showErrorSnackBar("مشکلی پیش آمده است");
            } else if (HttpService.cmpFirstLetter(
                code: response.statusCode!, num: 2)) {
              // write token
              // token.value = Map.from(response.data)['data']['access_token'];
              // await GetStorage().write('token', token.value);

              // create user
              Get.put<UserController>(
                  UserController(User.fromJson(Map.from(response.data)).obs));
              isAuth.value = true;
              update(['isAuth']);
            } else if (HttpService.cmpFirstLetter(
                code: response.statusCode!, num: 4)) {
              showErrorSnackBar("رمز وارد شده اشتباه است");
            } else {
              showErrorSnackBar(response.toString());
            }
          } on dio.DioException catch (error, stacktrace) {
            debugPrint("Exception occured: $error stackTrace: $stacktrace");
            String message = error.toString();
            if (error.type == dio.DioExceptionType.connectionError) {
              message = 'اتصال اینترنت را بررسی کنید';
            }
            // on 404 Error
            else if (error.type == dio.DioExceptionType.badResponse) {
              message = "رمز وارد شده اشتباه است";
            }
            showErrorSnackBar(message);
          }
          loading.value = false;
        }
        break;

      // -------------------------------------------------------- phone verification
      case LoginState.phoneVerification:
        {
          try {
            loading.value = true;
            final response = await verifyPhone();

            if (response == null) {
              showErrorSnackBar("مشکلی پیش آمده است");
            } else if (HttpService.cmpFirstLetter(
                code: response.statusCode!, num: 2)) {
              step.value = LoginState.signup;
              update(['step']);
            } else if (HttpService.cmpFirstLetter(
                code: response.statusCode!, num: 4)) {
              showErrorSnackBar("کد وارد شده اشتباه است");
            } else {
              showErrorSnackBar(response.toString());
            }
          } catch (error) {
            String message = error.toString();
            if (error is! dio.DioException) rethrow;

            if (error.type == dio.DioExceptionType.connectionError) {
              message = 'اتصال اینترنت را بررسی کنید';
            }
            // on 404 Error
            else if (error.type == dio.DioExceptionType.badResponse) {
              message = "کد وارد شده اشتباه است";
            }
            showErrorSnackBar(message);
          }
          loading.value = false;
        }
        break;

      // -------------------------------------------------------- signup
      case LoginState.signup:
        {
          try {
            loading.value = true;
            final response = await signup();

            if (response == null) {
              showErrorSnackBar("مشکلی پیش آمده است");
            } else if (HttpService.cmpFirstLetter(
                code: response.statusCode!, num: 2)) {
              // write token
              token.value = Map.from(response.data)['data']['access_token'];
              await GetStorage().write('token', token.value);

              // create user
              Get.put<UserController>(
                  UserController(User.fromJson(Map.from(response.data)).obs));
              isAuth.value = true;
              update(['isAuth']);
            } else {
              showErrorSnackBar(response.toString());
            }
          } catch (error) {
            String message = error.toString();
            if (error is! dio.DioException) rethrow;

            if (error.type == dio.DioExceptionType.connectionError) {
              message = 'اتصال اینترنت را بررسی کنید';
            }
            showErrorSnackBar(message);
          }
          loading.value = false;
        }
        break;

      // -------------------------------------------------------- pwdResetVerification
      case LoginState.pwdResetVerification:
        {
          try {
            loading.value = true;
            final response = await verifyResetPwd();

            if (response == null) {
              showErrorSnackBar("مشکلی پیش آمده است");
            } else if (HttpService.cmpFirstLetter(
                code: response.statusCode!, num: 2)) {
              step.value = LoginState.pwdReset;
              update(['step']);
            } else if (HttpService.cmpFirstLetter(
                code: response.statusCode!, num: 4)) {
              showErrorSnackBar("کد وارد شده اشتباه است");
            } else {
              showErrorSnackBar(response.toString());
            }
          } catch (error) {
            String message = error.toString();
            if (error is! dio.DioException) rethrow;

            if (error.type == dio.DioExceptionType.connectionError) {
              message = 'اتصال اینترنت را بررسی کنید';
            }
            // on 404 Error
            else if (error.type == dio.DioExceptionType.badResponse) {
              message = "کد وارد شده اشتباه است";
            }
            showErrorSnackBar(message);
          }
          loading.value = false;
        }
        break;

      // --------------------------------------------------------
      case LoginState.pwdReset:
        {
          try {
            loading.value = true;
            final response = await resetPwd();

            if (response == null) {
              showErrorSnackBar("مشکلی پیش آمده است");
            } else if (HttpService.cmpFirstLetter(
                code: response.statusCode!, num: 2)) {
              // sign in after reset
              if (!isAuth.value) {
                final r2 = await signin();
                if (r2 == null) {
                  showErrorSnackBar("مشکلی پیش آمده است");
                } else if (HttpService.cmpFirstLetter(
                    code: r2.statusCode!, num: 2)) {
                  isAuth.value = true;
                  update(['isAuth']);
                } else {
                  showErrorSnackBar(response.toString());
                }
              }
            } else {
              showErrorSnackBar(response.toString());
            }
          } catch (error) {
            String message = error.toString();
            if (error is! dio.DioException) rethrow;

            if (error.type == dio.DioExceptionType.connectionError) {
              message = 'اتصال اینترنت را بررسی کنید';
            }
            showErrorSnackBar(message);
          }
          loading.value = false;
        }
        break;

      // --------------------------------------------------------
      default:
        break;
    }
  }

  // ------------------------------------------------------------- phone number process

  Future<dio.Response<dynamic>?> checkPhone() async {
    return await HttpService.postMehod(APIConsts.phoneCheck, {
      'phone': phoneNumber.value,
    });
  }

  Future<dio.Response<dynamic>?> registerPhone() async {
    final res = await HttpService.postMehod(APIConsts.phoneReg, {
      'phone': phoneNumber.value,
    });
    return res;
  }

  Future<dio.Response<dynamic>?> verifyPhone() async {
    final res = await HttpService.postMehod(APIConsts.phoneRegVerify, {
      'phone': phoneNumber.value,
      'code': code.value,
    });
    return res;
  }

  // ------------------------------------------------------------- Reset password process
  Future<dio.Response<dynamic>?> sendResetPwd() async {
    final res = await HttpService.postMehod(APIConsts.pwdReset, {
      'phone': phoneNumber.value,
    });
    return res;
  }

  Future<dio.Response<dynamic>?> verifyResetPwd() async {
    final res = await HttpService.postMehod(APIConsts.pwdResetVerify, {
      'phone': phoneNumber.value,
      'code': code.value,
    });
    return res;
  }

  Future<dio.Response<dynamic>?> resetPwd() async {
    final res = await HttpService.postMehod(APIConsts.pwdResetChange, {
      'phone': phoneNumber.value,
      'password': newPassword,
      'password_confirmation': newPassword,
    });
    return res;
  }

  // ------------------------------------------------------------- login process

  Future<dio.Response<dynamic>?> signup() async {
    final res = await HttpService.postMehod(APIConsts.register, {
      'phone': phoneNumber.value,
      'nic_name': surname.value,
      'password': password.value,
      'password_confirmation': password.value,
      'gender': sex.value ? 'male' : 'female',
    });
    return res;
  }

  Future<dio.Response<dynamic>?> signin() async {
    final res = await HttpService.postMehod(APIConsts.login, {
      'phone': phoneNumber.value,
      'password': password.value,
    });
    return res;
  }

  void addAuthListener() {
    ever(Get.find<AuthController>().isAuth, (bool isAuth) {
      if (isAuth) {
        Get.toNamed('/home');
      } else {
        Get.toNamed('/login');
      }
    });
  }

  Future<dio.Response<dynamic>?> tryAutoSignin() async {
    token.value = await GetStorage().read('token');
    final res =
        await HttpService.postMehod(APIConsts.login, {}, token: token.value);
    if (HttpService.cmpFirstLetter(code: res!.statusCode!, num: 2)) {
      // write token
      token.value = Map.from(res.data)['data']['access_token'];
      await GetStorage().write('token', token.value);

      // create user
      Get.put<UserController>(
          UserController(User.fromJson(Map.from(res.data)).obs));
      isAuth.value = true;
      update(['isAuth']);
    }
    return res;
  }

  Future<dio.Response<dynamic>?> logout() async {
    await GetStorage().remove('token');
    final res =
        await HttpService.postMehod(APIConsts.logout, {}, token: token.value);
    if (HttpService.cmpFirstLetter(code: res!.statusCode!, num: 2)) {
      Get.delete<UserController>();
      isAuth.value = false;
      update(['isAuth']);
    }
    return res;
  }
}
