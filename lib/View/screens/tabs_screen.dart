import 'package:food_app/Controller/settings.dart';
import 'package:food_app/Model/meal.dart';
import 'package:food_app/View/widgets/categories_grid.dart';
import 'package:food_app/View/widgets/Drawer.dart';
import 'package:food_app/View/widgets/Favorite_meal.dart';
import 'package:food_app/View/widgets/search_item.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

RxInt _currentPage = 0.obs;
RxList<Meal> _mealsFound = RxList();
TextEditingController _searchtext = TextEditingController();
RxString _text = "".obs;

// change index
void _selectPage(int index) {
  _currentPage.value = index;
  _searchtext.clear();
}

class TabsScreen extends StatelessWidget {
  static const routeName = "/home";
  const TabsScreen({Key? key}) : super(key: key);
  // pages
  static const List<Map<String, Object>> _pages = [
    {'page': Categories(), 'title': 'Categories'},
    {'page': Favoritemeal(), 'title': "Your Favorite Meals"}
  ];

  // simple search
  void _searchdMeal(String text) {
    _mealsFound.value = Get.find<Settings>().simpleMealSearch(
      text: text,
      inFavs: _currentPage.value == 1,
    );
  }

  void _temporaryRemoveMeal(Meal meal) {
    _mealsFound.remove(meal);
  }

  @override
  Widget build(BuildContext context) {
    // add search listener
    _searchtext.addListener(() {
      _text.value = _searchtext.text;
      _searchdMeal(_text.value);
      debugPrint("listen");
    });

    return Scaffold(
      // --------------------------------------------------------------
      appBar: const HomeAppBar(pages: _pages),
      // --------------------------------------------------------------
      bottomNavigationBar: const BottomNav(),
      // --------------------------------------------------------------
      body: Obx(
        () => _text.value.isEmpty

            // if not searching
            ? _pages[_currentPage.value]['page'] as Widget

            // if searching...
            : _mealsFound.isEmpty
                ? const Center(
                    child: Text("No match found"),
                  )
                : ListView.builder(
                    itemBuilder: (context, index) => SearchItem(
                      meal: _mealsFound.elementAt(index),
                      remove: _temporaryRemoveMeal,
                    ),
                    itemCount: _mealsFound.length,
                  ),
      ),
      // --------------------------------------------------------------
      drawer: const Drwer(),
      drawerEdgeDragWidth: 160,
    );
  }
}

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  final List<Map<String, Object>> _pages;
  const HomeAppBar({Key? key, required List<Map<String, Object>> pages})
      : _pages = pages,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(_pages[_currentPage.value]['title'] as String),
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
          suffixIcon: const Icon(Icons.clear),
          onSuffixTap: () {
            _searchtext.clear();
          },
          onSubmitted: (str) {},
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
      ],
    );
  }
}

class BottomNav extends StatelessWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    // stateful
    return Obx(
      () => SizedBox(
        height: screenSize.height * 0.07,
        child: BottomNavigationBar(
          backgroundColor: Theme.of(context).primaryColor,
          onTap: _selectPage,
          //chane selected item style
          selectedItemColor: Colors.yellow[400],
          unselectedItemColor: Colors.white,
          currentIndex: _currentPage.value,
          iconSize: screenSize.height * 0.07 * 0.5,
          selectedFontSize: screenSize.height * 0.07 * 0.2,
          unselectedFontSize: screenSize.height * 0.07 * 0.2,
          elevation: 8,
          type: BottomNavigationBarType.shifting,
          //bottombar items
          items: [
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: const Icon(Icons.category),
                label: 'Categories'),
            BottomNavigationBarItem(
                backgroundColor: Theme.of(context).primaryColor,
                icon: const Icon(Icons.star),
                label: 'Favorites'),
          ],
        ),
      ),
    );
  }
}
