import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/Service/http_service.dart';
import 'package:get/get.dart';

import 'package:food_app/Constants/app_colors.dart';
import 'package:food_app/Controller/auth_controller.dart';
import 'package:food_app/gen/assets.gen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = "/login";

  LoginScreen({Key? key}) : super(key: key);

  final appbarSize = 50;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final auth = Get.find<AuthController>();
  static Timer? timer;

  // set button text by step
  String _buttonText() {
    switch (auth.step.value) {
      case LoginState.phone:
        return "تایید و ادامه";
      case LoginState.pwdResetVerification:
      case LoginState.phoneVerification:
        return "ادامه";
      case LoginState.signin:
        return "ورود";
      case LoginState.signup:
        return "ثبت نام";
      case LoginState.pwdReset:
        return "تایید";
      default:
        return "Error!";
    }
  }

  // select current widget by step
  Widget _loginForm() {
    // TODO: timer has some bugs
    void startTimer(RxInt counter) {
      if (timer != null) timer!.cancel();
      timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) {
          if (counter.value == 0) {
            timer.cancel();
          } else {
            counter.value--;
          }
        },
      );
    }

    switch (auth.step.value) {
      case LoginState.phone:
        {
          return _OneField(
            key: UniqueKey(),
            titleText: "ورود یا ثبت نام",
            subtitleText: "شماره تلفن همراه خود را وارد کنید",
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.phone,
            obscureText: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "شماره موبایل نباید خالی باشد";
              } else if (value[0] != '0' ||
                  value[1] != '9' ||
                  value.length != 11) {
                return "شماره وارد شده صحیح نمیباشد";
              } else {
                return null;
              }
            },
            onSaved: (value) async {
              auth.phoneNumber.value = value!;
            },
            startTimer: (RxInt t) {},
          );
        }

      case LoginState.signin:
        {
          return _OneField(
            key: UniqueKey(),
            titleText: "ورود",
            subtitleText: "رمز عبور خود را وارد کنید",
            inputFormatters: const [],
            keyboardType: TextInputType.text,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "رمز نمیتواند خالی باشد";
              } else {
                return null;
              }
            },
            onSaved: (value) async {
              auth.password.value = value!;
            },
            startTimer: (RxInt t) {},
          );
        }

      case LoginState.pwdResetVerification:
        {
          return _OneField(
            key: UniqueKey(),
            titleText: "بازیابی رمز عبور",
            subtitleText: "رمز  یک بار مصرف ارسالی را وارد کنید",
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            obscureText: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "کد نمیتواند خالی باشد";
              } else if (timer == null || !timer!.isActive) {
                return "زمان کد تمام شده است";
              }
              // TODO: use flutter_form_bloc and await for validaion here
              // else if (!auth.checkCode(value)) {
              // return "کد وارد شده صحیح نمیباشد";
              // }
              else {
                return null;
              }
            },
            onSaved: (value) async {
              timer!.cancel();
            },
            startTimer: startTimer,
          );
        }

      case LoginState.phoneVerification:
        {
          return _OneField(
            key: UniqueKey(),
            titleText: "ثبت نام",
            subtitleText: "رمز  یک بار مصرف ارسالی را وارد کنید",
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            obscureText: false,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "کد نمیتواند خالی باشد";
              } else if (timer == null || !timer!.isActive) {
                return "زمان کد تمام شده است";
              }
              // TODO: use flutter_form_bloc and await for validaion here
              // else if (!auth.checkCode(value)) {
              // return "کد وارد شده صحیح نمیباشد";
              // }
              else {
                return null;
              }
            },
            onSaved: (value) async {
              timer!.cancel();
            },
            startTimer: startTimer,
          );
        }

      case LoginState.pwdReset:
        return _RestPassword();

      case LoginState.signup:
        return _Signup();

      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Obx(
            () => AppBar(
              backgroundColor: SolidColors.primary,
              elevation: 0,
              leading: auth.step.value == LoginState.phone
                  ? Container()
                  : BackButton(
                      onPressed: () {
                        auth.step.value = LoginState.phone;
                        if (timer != null) timer!.cancel();
                      },
                    ),
            ),
          ),
        ),
        // top
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // background image
                  Positioned(
                    top: 0,
                    child: SizedBox(
                      height: screenSize.height * 0.5 - appbarSize,
                      width: screenSize.width,
                      child: SvgPicture.asset(
                        Assets.images.rectangle,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  // lable
                  Positioned(
                    top: screenSize.height * 0.07 - appbarSize,
                    child: Text(
                      "پیش بند",
                      style: Get.theme.textTheme.displayLarge,
                    ),
                  ),

                  // title and form
                  Obx(() => Form(key: _form, child: _loginForm())),

                  // button
                  Positioned(
                    bottom: screenSize.height * 0.1,
                    child: Container(
                      height: 50,
                      width: 160,
                      decoration: const BoxDecoration(
                        color: SolidColors.primary,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      // waiting indicator
                      child: Obx(
                        () => auth.loading.value
                            ? const Center(
                                child:
                                    SpinKitFadingCircle(color: SolidColors.bg))
                            : InkWell(
                                onTap: () => auth.saveForm(_form),
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SvgPicture.asset(
                                          Assets.images.arrowLeftSolid),
                                      Text(
                                        _buttonText(),
                                        style: Get.theme.textTheme.displaySmall,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OneField extends StatelessWidget {
  _OneField({
    Key? key,
    required this.titleText,
    required this.subtitleText,
    required this.validator,
    required this.onSaved,
    required this.inputFormatters,
    required this.keyboardType,
    required this.obscureText,
    required this.startTimer,
  }) : super(key: key);

  final auth = Get.find<AuthController>();

  final String titleText;
  final String subtitleText;
  final String? Function(String?) validator;
  final Future Function(String?) onSaved;
  final List<TextInputFormatter> inputFormatters;
  final TextInputType keyboardType;
  final bool obscureText;
  final Function startTimer;

  static final RxInt counter = 120.obs;

  void resetPwdFunction() async {
    try {
      auth.loading.value = true;
      final response = await auth.sendResetPwd();

      if (response == null) {
        auth.showErrorSnackBar("مشکلی پیش آمده است");
      } else if (HttpService.cmpFirstLetter(
          code: response.statusCode!, num: 2)) {
        auth.step.value = LoginState.pwdReset;
        auth.update(['step']);
      } else {
        auth.showErrorSnackBar("مشکلی پیش آمده است ${response.statusCode}");
      }
    } catch (error) {
      log(error.toString());
      auth.showErrorSnackBar(error.toString());
    }
    auth.loading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    // start timer if not started
    if (counter.value == 120) startTimer(counter);
    final screenSize = MediaQuery.sizeOf(context);
    return Positioned(
      height: 320,
      width: screenSize.width,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            titleText,
            style: Get.theme.textTheme.displayMedium,
          ),
          const SizedBox(height: 8),
          Text(
            subtitleText,
            style: Get.theme.textTheme.displaySmall,
          ),
          const SizedBox(height: 12),
          // form
          Container(
            width: screenSize.width * 0.88,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Get.theme.scaffoldBackgroundColor,
              border: Border.all(color: SolidColors.disabled),
            ),
            child: Center(
              child: TextFormField(
                  style: Get.theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                  inputFormatters: inputFormatters,
                  keyboardType: keyboardType,
                  obscureText: obscureText,
                  validator: validator,
                  onSaved: onSaved),
            ),
          ),
          const SizedBox(height: 12),

          // show forgot password
          if (auth.step.value == LoginState.signin)
            TextButton(
              onPressed: resetPwdFunction,
              child: const Text("رمز عبور خود را فراموش کرده اید؟"),
            )

          // show counter
          else if (auth.step.value == LoginState.pwdResetVerification ||
              auth.step.value == LoginState.phoneVerification)
            // left and right padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Obx(
                () => Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // if timer not finished
                    counter.value != 0
                        ? Text(
                            '${(Duration(seconds: counter.value))}'
                                .substring(2)
                                .split('.')[0],
                            // .padLeft(4, '0'),
                            style: Get.theme.textTheme.bodySmall!
                                .copyWith(color: SolidColors.primary),
                          )
                        : TextButton(
                            onPressed: () {
                              // send request
                              counter.value = 120;
                              startTimer(counter);
                            },
                            child: Text(
                              "ارسال مجدد",
                              style: Get.theme.textTheme.bodySmall!
                                  .copyWith(color: SolidColors.primary),
                            ),
                          ),
                    Text(
                      "ارسال دوباره رمز یکبار مصرف",
                      style: Get.theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}

class _RestPassword extends StatelessWidget {
  _RestPassword({Key? key}) : super(key: key);

  final resetPwdCtrl = TextEditingController();
  final auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Positioned(
      height: 320,
      width: screenSize.width,
      child: Column(children: [
        const SizedBox(height: 10),
        Text(
          "بازیابی رمز عبور",
          style: Get.theme.textTheme.displayMedium,
        ),
        const SizedBox(height: 8),
        Text(
          "رمز عبور جدیدتان را وارد کنید",
          style: Get.theme.textTheme.displaySmall,
        ),
        const SizedBox(height: 12),
        // form
        Flexible(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            surfaceTintColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    obscureText: true,
                    controller: resetPwdCtrl,
                    style: Get.theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration()
                        .applyDefaults(Get.theme.inputDecorationTheme)
                        .copyWith(labelText: "رمز عبور جدید *"),
                    validator: (value) {
                      if (value == null || value.length < 8) {
                        return "رمز عبور باید بیشتر از 8 حرف داشته باشد";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    style: Get.theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration()
                        .applyDefaults(Get.theme.inputDecorationTheme)
                        .copyWith(labelText: "رمز عبور جدید *"),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value != resetPwdCtrl.text) {
                        return "تکرار رمز مطابقت ندارد";
                      }
                      return null;
                    },
                    onSaved: (value) async {
                      auth.newPassword.value = value!;
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class _Signup extends StatelessWidget {
  _Signup({Key? key}) : super(key: key);

  final resetPwdCtrl = TextEditingController();
  final auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return Positioned(
      top: 190 - 50,
      height: screenSize.height * 0.55,
      width: screenSize.width,
      child: Column(children: [
        Text(
          "ثبت نام",
          style: Get.theme.textTheme.displayMedium,
        ),
        const SizedBox(height: 12),
        // form
        Flexible(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 25),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // name
                  TextFormField(
                    style: Get.theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration()
                        .applyDefaults(Get.theme.inputDecorationTheme)
                        .copyWith(labelText: "نام کاربری"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "نام کاربری نمیتواند خالی باشد";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      auth.name.value = value!;
                    },
                  ),

                  // surname
                  TextFormField(
                    style: Get.theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration()
                        .applyDefaults(Get.theme.inputDecorationTheme)
                        .copyWith(labelText: "نام مستعار"),
                    onSaved: (value) {
                      auth.surname.value = value ?? "";
                    },
                  ),

                  // password
                  TextFormField(
                    controller: resetPwdCtrl,
                    obscureText: true,
                    style: Get.theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration()
                        .applyDefaults(Get.theme.inputDecorationTheme)
                        .copyWith(labelText: "رمز عبور حدید"),
                    validator: (value) {
                      if (value == null || value.length < 8) {
                        return "رمز عبور باید بیشتر از 8 حرف داشته باشد";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      auth.password.value = value!;
                    },
                  ),

                  // repeat password
                  TextFormField(
                    obscureText: true,
                    style: Get.theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration()
                        .applyDefaults(Get.theme.inputDecorationTheme)
                        .copyWith(labelText: "تکرار رمز عبور جدید"),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value != resetPwdCtrl.text) {
                        return "تکرار رمز مطابقت ندارد";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      auth.password.value = value!;
                    },
                  ),

                  // gender
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ChoiceChip(
                          label: SizedBox(
                            width: 100,
                            height: 36,
                            child: Text(
                              "آقا",
                              textAlign: TextAlign.center,
                              style: Get.theme.textTheme.bodyMedium!.copyWith(
                                color: auth.sex.value == true
                                    ? Colors.white
                                    : Colors.grey[700],
                              ),
                            ),
                          ),
                          selected: auth.sex.value,
                          selectedColor: SolidColors.primary,
                          onSelected: (value) {
                            auth.sex.value = value;
                          },
                        ),
                        ChoiceChip(
                          label: SizedBox(
                            width: 100,
                            height: 36,
                            child: Text(
                              "خانم",
                              textAlign: TextAlign.center,
                              style: Get.theme.textTheme.bodyMedium!.copyWith(
                                color: auth.sex.value == false
                                    ? Colors.white
                                    : Colors.grey[700],
                              ),
                            ),
                          ),
                          selected: !auth.sex.value,
                          selectedColor: SolidColors.primary,
                          onSelected: (value) {
                            auth.sex.value = !value;
                          },
                        ),
                        Text("جنسیت", style: Get.theme.textTheme.bodySmall)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
