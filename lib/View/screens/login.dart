import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_app/Constants/app_colors.dart';
import 'package:food_app/Controller/auth_controller.dart';
import 'package:food_app/gen/assets.gen.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = "/login";

  static const appbarSize = 50;

  LoginScreen({Key? key}) : super(key: key);

  // form state
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final auth = Get.find<AuthController>();

  // set button text by step
  String _buttonText() {
    switch (auth.step.value) {
      case LoginState.phone:
        return "تایید و ادامه";
      case LoginState.forgotSmsVld:
      case LoginState.signupSmsVld:
        return "ادامه";
      case LoginState.signin:
        return "ورود";
      case LoginState.signup:
        return "ثبت نام";
      case LoginState.resetPwd:
        return "تایید";
      default:
        return "Error!";
    }
  }

  void _saveForm() async {
    // validate and save
    if (!_form.currentState!.validate()) return;
    _form.currentState!.save();

    switch (auth.step.value) {
      // --------------------------------------------------------
      case LoginState.phone:
        {
          auth.loading.value = true;
          final response = await auth.checkNumber();
          auth.loading.value = false;

          // TODO check response
          if (response == "has account") {
            auth.step.value = LoginState.signin;
          } else if (response == "has not account") {
            await auth.sendSmsValidation();
            auth.step.value = LoginState.signupSmsVld;
          } else if (response == "connection lost") {
            auth.showErrorSnackBar("دستگاه به اینترنت متصل نیست");
          } else {
            auth.showErrorSnackBar("شماره وارد شده صحیح نمیباشد");
          }
        }
        break;

      // --------------------------------------------------------
      case LoginState.signin:
        {
          auth.loading.value = true;
          final response = await auth.signin();
          auth.loading.value = false;

          // TODO check response
          if (response == "wrong password") {
            auth.showErrorSnackBar("رمز وارد شده اشتباه است");
          }
        }
        break;

      // --------------------------------------------------------
      case LoginState.forgotSmsVld:
        {
          auth.step.value = LoginState.resetPwd;
        }
        break;

      // --------------------------------------------------------
      case LoginState.signupSmsVld:
        {
          auth.step.value = LoginState.signup;
        }
        break;

      // --------------------------------------------------------
      case LoginState.resetPwd:
        {
          auth.loading.value = true;
          final response = await auth.changePassword();
          auth.loading.value = false;

          // TODO check response
          if (response == "...") {
            auth.step.value = LoginState.phone;
          } else {
            auth.showErrorSnackBar("response");
          }
        }
        break;

      // --------------------------------------------------------
      case LoginState.signup:
        {
          auth.loading.value = true;
          final response = await auth.signup();
          auth.loading.value = false;

          // TODO check response
          if (response == "...") {
            auth.step.value = LoginState.phone;
          } else {
            auth.showErrorSnackBar("reponse");
          }
        }
        break;

      // --------------------------------------------------------
      default:
        break;
    }
  }

  // select current widget by step
  Widget _loginForm() {
    switch (auth.step.value) {
      case LoginState.phone:
        return _OneField(key: UniqueKey());
      case LoginState.signin:
        return _OneField(key: UniqueKey());
      case LoginState.forgotSmsVld:
        return _OneField(key: UniqueKey());
      case LoginState.signupSmsVld:
        return _OneField(key: UniqueKey());
      case LoginState.resetPwd:
        return _RestPassword();
      case LoginState.signup:
        return _Signup();
      default:
        return _OneField(key: UniqueKey());
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
                      child: Image(
                        image: Assets.images.rectangle12.provider(),
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
                                onTap: _saveForm,
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
  }) : super(key: key);

  final auth = Get.find<AuthController>();

  late String titleText;
  late String subtitleText;
  late String? Function(String?) validator;
  late Future Function(String?) onSaved;
  late List<TextInputFormatter> inputFormatters;
  late TextInputType keyboardType;
  late bool obscureText;

  Timer? timer;
  final RxInt counter = 5.obs;
  void startTimer() {
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

  // set texts and fucntions for each field
  void setAtts() {
    switch (auth.step.value) {
      case LoginState.phone:
        {
          titleText = "ورود یا ثبت نام";
          subtitleText = "شماره تلفن همراه خود را وارد کنید";
          inputFormatters = [FilteringTextInputFormatter.digitsOnly];
          keyboardType = TextInputType.phone;
          obscureText = false;
          validator = (value) {
            if (value == null || value.isEmpty) {
              return "شماره موبایل نباید خالی باشد";
            } else if (value[0] != '0' ||
                value[1] != '9' ||
                value.length != 11) {
              return "شماره وارد شده صحیح نمیباشد";
            } else {
              return null;
            }
          };
          onSaved = (value) async {
            auth.phoneNumber.value = value!;
          };
        }
        break;
      case LoginState.signin:
        {
          titleText = "ورود";
          subtitleText = "رمز عبور خود را وارد کنید";
          inputFormatters = [];
          keyboardType = TextInputType.text;
          obscureText = true;
          validator = (value) {
            if (value == null || value.isEmpty) {
              return "رمز نمیتواند خالی باشد";
            } else {
              return null;
            }
          };
          onSaved = (value) async {
            auth.password.value = value!;
          };
        }
        break;
      case LoginState.signupSmsVld:
        {
          titleText = "ثبت نام";
          subtitleText = "کد  یک بار مصرف ارسالی را وارد کنید";
          inputFormatters = [FilteringTextInputFormatter.digitsOnly];
          keyboardType = TextInputType.number;
          obscureText = false;
          startTimer();
          validator = (value) {
            if (value == null || value.isEmpty) {
              return "کد نمیتواند خالی باشد";
            } else if (timer == null || !timer!.isActive) {
              return "زمان کد تمام شده است";
            } else if (!auth.checkCode(value)) {
              return "کد وارد شده صحیح نمیباشد";
            } else {
              return null;
            }
          };
          onSaved = (value) async {
            timer!.cancel();
          };
        }
        break;
      case LoginState.forgotSmsVld:
        {
          titleText = "بازیابی رمز عبور";
          subtitleText = "بازیابی رمز عبور";
          inputFormatters = [FilteringTextInputFormatter.digitsOnly];
          keyboardType = TextInputType.number;
          obscureText = false;
          startTimer();
          validator = (value) {
            if (value == null || value.isEmpty) {
              return "کد نمیتواند خالی باشد";
            } else if (timer == null || !timer!.isActive) {
              return "زمان کد تمام شده است";
            } else if (!auth.checkCode(value)) {
              return "کد وارد شده صحیح نمیباشد";
            } else {
              return null;
            }
          };
          onSaved = (value) async {
            timer!.cancel();
          };
        }
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    // set attributes
    setAtts();
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
            height: 90,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Get.theme.scaffoldBackgroundColor),
            child: TextFormField(
                style: Get.theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
                inputFormatters: inputFormatters,
                keyboardType: keyboardType,
                obscureText: obscureText,
                decoration: InputDecoration(
                  errorStyle: Get.theme.textTheme.labelMedium!.copyWith(
                    color: Colors.red,
                  ),
                  contentPadding: const EdgeInsets.all(20),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide:
                        BorderSide(color: SolidColors.primary, width: 1),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: SolidColors.disabled),
                  ),
                ),
                validator: validator,
                onSaved: onSaved),
          ),
          const SizedBox(height: 12),

          // show forgot password
          if (auth.step.value == LoginState.signin)
            TextButton(
              onPressed: () async {
                auth.loading.value = true;
                // TODO check response
                await auth.sendresetPwdValidation();
                auth.loading.value = false;
                auth.step.value = LoginState.forgotSmsVld;
              },
              child: const Text("رمز عبور خود را فراموش کرده اید؟"),
            )

          // show counter
          else if (auth.step.value == LoginState.forgotSmsVld ||
              auth.step.value == LoginState.signupSmsVld)
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
                              startTimer();
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
                    decoration: InputDecoration(
                      errorStyle: Get.theme.textTheme.labelMedium!.copyWith(
                        color: Colors.red,
                      ),
                      labelText: "رمز عبور جدید *",
                      labelStyle:
                          Get.theme.textTheme.bodySmall!.copyWith(fontSize: 14),
                      contentPadding: const EdgeInsets.all(8),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide:
                            BorderSide(color: SolidColors.primary, width: 1),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: SolidColors.disabled),
                      ),
                    ),
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
                    decoration: InputDecoration(
                      errorStyle: Get.theme.textTheme.labelMedium!.copyWith(
                        color: Colors.red,
                      ),
                      labelText: "تکرار رمز عبور جدید *",
                      labelStyle:
                          Get.theme.textTheme.bodySmall!.copyWith(fontSize: 14),
                      contentPadding: const EdgeInsets.all(8),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide:
                            BorderSide(color: SolidColors.primary, width: 1),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: SolidColors.disabled),
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value != resetPwdCtrl.text) {
                        return "تکرار رمز مطابقت ندارد";
                      }
                      return null;
                    },
                    onSaved: (value) async {
                      auth.resetPwd.value = value!;
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
                    decoration: InputDecoration(
                      errorStyle: Get.theme.textTheme.labelMedium!.copyWith(
                        color: Colors.red,
                      ),
                      labelText: "نام کاربری *",
                      labelStyle:
                          Get.theme.textTheme.bodySmall!.copyWith(fontSize: 14),
                      contentPadding: const EdgeInsets.all(8),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide:
                            BorderSide(color: SolidColors.primary, width: 1),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: SolidColors.disabled),
                      ),
                    ),
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
                    decoration: InputDecoration(
                      errorStyle: Get.theme.textTheme.labelMedium!.copyWith(
                        color: Colors.red,
                      ),
                      labelText: "نام مستعار",
                      labelStyle:
                          Get.theme.textTheme.bodySmall!.copyWith(fontSize: 14),
                      contentPadding: const EdgeInsets.all(8),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide:
                            BorderSide(color: SolidColors.primary, width: 1),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: SolidColors.disabled),
                      ),
                    ),
                    onSaved: (value) {
                      auth.surname.value = value!;
                    },
                  ),

                  // password
                  TextFormField(
                    controller: resetPwdCtrl,
                    obscureText: true,
                    style: Get.theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      errorStyle: Get.theme.textTheme.labelMedium!.copyWith(
                        color: Colors.red,
                      ),
                      labelText: "رمز عبور جدید *",
                      labelStyle:
                          Get.theme.textTheme.bodySmall!.copyWith(fontSize: 14),
                      contentPadding: const EdgeInsets.all(8),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide:
                            BorderSide(color: SolidColors.primary, width: 1),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: SolidColors.disabled),
                      ),
                    ),
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
                    decoration: InputDecoration(
                      errorStyle: Get.theme.textTheme.labelMedium!.copyWith(
                        color: Colors.red,
                      ),
                      labelText: "تکرار رمز عبور جدید *",
                      labelStyle:
                          Get.theme.textTheme.bodySmall!.copyWith(fontSize: 14),
                      contentPadding: const EdgeInsets.all(8),
                      focusedBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide:
                            BorderSide(color: SolidColors.primary, width: 1),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: SolidColors.disabled),
                      ),
                    ),
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
