import 'package:FoodApp/screens/Meal_Details.dart';
import 'package:FoodApp/screens/Tabs_screen.dart';
import 'package:FoodApp/widgets/Filters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/Setting_Screen.dart';
import './screens/category_meals_screen.dart';
import 'screens/Favorites.dart';
import 'Providers/Settings.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

//filters
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //this method is better for grid and lists objects that are created before
        // ChangeNotifierProvider.value(
        //   value: Settings(),
        // ),
        //this method is better for uncreated items
        ChangeNotifierProvider(
          create: (ctx) => Settings(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'DeliMeals',
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            // accentColor: Colors.amber,
            canvasColor: Color.fromRGBO(255, 254, 229, 1),
            fontFamily: 'Raleway',
            highlightColor: Colors.pink[50],
            primaryColor: Colors.pink,
            textTheme: ThemeData.light().textTheme.copyWith(
                  //drawer
                  bodyText1: TextStyle(fontSize: 23, color: Colors.black),
                  //body
                  bodyText2: TextStyle(
                      fontSize: 21,
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                  //titles
                  subtitle1: TextStyle(
                    fontFamily: '(50)',
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
            colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.pink)
                .copyWith(background: Colors.white)),
        // home: CategoriesScreen(),
        initialRoute: '/', // default is '/'
        routes: {
          //Starting Page
          '/': (ctx) => TabsScreen(),
          'CategoryMealsScreen': (_) => CategoryMealsScreen(),
          'Favorites-screen': (_) => Favorites(),
          'mealscreen': (_) => Mealscreen(),
          Filters.routeName: (_) => Filters(),
          SettingScreeen.routeName: (_) => SettingScreeen()
        },
        //when pages are not available go to some page
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (ctx) => TabsScreen());
        },
      ),
    );
  }
}
