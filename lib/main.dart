import 'package:flutter/material.dart';
import 'package:food_app/Controller/auth_controller.dart';
import 'package:food_app/Controller/user_controller.dart';
import 'package:food_app/Model/user.dart';
import 'package:get/get.dart';

import 'package:food_app/Routs/pages.dart';
import 'package:food_app/Theme/app_theme.dart';
import 'package:food_app/View/screens/home_screen.dart';
import 'package:get_storage/get_storage.dart';

/*
Dependency heirarchy:
  AuthController
    UserController
      FoodController
        CommentController
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController());
  // TODO: remove this after test
  Get.put(UserController(User(
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    name: 'Test',
    gender: 'male',
    id: 'id',
    username: 'someone',
    phone: '0933',
  ).obs));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // locale: const Locale('fa'),
      debugShowCheckedModeBanner: false,
      title: 'Pishband',
      theme: appTheme(),
      getPages: AppPages.pages,
      // TODO: change this to login after adding API
      initialRoute: '/home',
      // on startup
      onInit: () async {
        final auth = Get.find<AuthController>();
        auth.loading.value = true;
        await GetStorage.init();
        auth.addAuthListener();
        // await auth.tryAutoSignin();
        auth.loading.value = false;
      },
      // routes: {
      //   '/home': (_) => const HomeScreen(),
      //   CategoryScreen.routeName: (_) => const CategoryScreen(),
      //   FoodScreen.routeName: (_) => const FoodScreen(),
      //   SettingScreen.routeName: (_) => const SettingScreen(),
      //   EditScreen.routeName: (_) => EditScreen(),
      //   CrashScreen.routeName: (_) => const CrashScreen(),
      // },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
            builder: (ctx) => HomeScreen(), settings: settings);
      },
    );
  }
}
