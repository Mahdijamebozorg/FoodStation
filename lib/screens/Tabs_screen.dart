import 'package:FoodApp/Providers/Settings.dart';
import 'package:FoodApp/models/meal.dart';
import 'package:FoodApp/screens/Favorites.dart';
import 'package:FoodApp/screens/categories_screen.dart';
import 'package:FoodApp/widgets/Drawer.dart';
import 'package:FoodApp/widgets/search_item.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabsScreen extends StatefulWidget {
  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  // ----------------------------------

  //pages
  List<Map<String, Object>> _pages = [
    {'page': CategoriesScreen(), 'title': 'Categories'},
    {'page': Favorites(), 'title': "Your Favorite Meals"}
  ];

  // current page
  int _currentPage = 0;

  //page index
  void _selectPage(int index) {
    setState(() {
      _currentPage = index;
      _searchtext.clear();
    });
  }

  // ----------------------------------

  List<Meal> mealsFound = [];

  //searching in meals
  void searchdMeal(String text) {
    setState(() {
      final setting = Provider.of<Settings>(context, listen: false);
      mealsFound = _currentPage == 0
          // if in main tab
          ? setting.availableMeals
              .where((meal) => meal.title.contains(text.toLowerCase()))
              .toList()

          // if in favorite tab
          : setting.favoriteMeals
              .where((meal) => meal.title.contains(text.toLowerCase()))
              .toList();
    });
  }

  void temporaryRemoveMeal(Meal meal) {
    setState(() {
      mealsFound.remove(meal);
    });
  }

  // search text
  TextEditingController _searchtext = TextEditingController();

  // ----------------------------------

  @override
  void initState() {
    // listen to input search text
    _searchtext.addListener(() {
      searchdMeal(_searchtext.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchtext.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Settings setttings = Provider.of<Settings>(context, listen: false);

    //screen details
    final Size screenSize = setttings.screenSize(context);
    return Scaffold(
      // --------------------------------------------------------------
      appBar: AppBar(
        title: Text(_pages[_currentPage]['title'] as String),
        centerTitle: true,
        actions: [
          AnimSearchBar(
            color: Theme.of(context).primaryColor,
            searchIconColor: Theme.of(context).colorScheme.onPrimary,
            helpText: "Enter food name",
            width: 400,
            textController: _searchtext,
            autoFocus: true,
            boxShadow: false,
            suffixIcon: Icon(Icons.clear),
            onSuffixTap: () {
              setState(() {
                _searchtext.clear();
              });
            },
            onSubmitted: (str) {},
          ),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      // --------------------------------------------------------------
      bottomNavigationBar: Container(
        height: screenSize.height * 0.07,
        child: BottomNavigationBar(
          backgroundColor: Theme.of(context).primaryColor,
          onTap: _selectPage,
          //chane selected item style
          selectedItemColor: Colors.yellow[400],
          unselectedItemColor: Colors.white,
          currentIndex: _currentPage,
          iconSize: screenSize.height * 0.07 * 0.5,
          selectedFontSize: screenSize.height * 0.07 * 0.2,
          unselectedFontSize: screenSize.height * 0.07 * 0.2,
          elevation: 8,
          type: BottomNavigationBarType.shifting,
          //bottombar items
          items: [
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.category),
                label: 'Categories'),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: Icon(Icons.star),
                label: 'Favorites'),
          ],
        ),
      ),
      // --------------------------------------------------------------
      body: _searchtext.text.isEmpty

          // if not searching
          ? _pages[_currentPage]['page'] as Widget

          // if searching...
          : mealsFound.isEmpty
              ? Center(
                  child: Text("No match found"),
                )
              : ListView.builder(
                  itemBuilder: (context, index) => SearchItem(
                    meal: mealsFound.elementAt(index),
                    remove: temporaryRemoveMeal,
                  ),
                  itemCount: mealsFound.length,
                ),
      // --------------------------------------------------------------
      drawer: Drwer(),
      drawerEdgeDragWidth: 160,
    );
  }
}
