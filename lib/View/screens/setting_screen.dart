import 'package:food_app/Controller/food_controller.dart';
import 'package:food_app/Controller/user_controller.dart';
import 'package:food_app/View/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingScreen extends StatelessWidget {
  static const routeName = '/setting';
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Filters'),
        ),
        //body
        body: const Column(
          children: [
            Flexible(child: Filters()),
            Flexible(child: IngredientsChoice()),
          ],
        ),
        drawer: const Drwer(),
        drawerEdgeDragWidth: 160,
      ),
    );
  }
}

class Filters extends StatelessWidget {
  const Filters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserController settting = Get.find<UserController>();

    //filters setted in setting
    RxBool isGlutenFree = settting.filters['isGlutenFree']!.obs;
    RxBool isVegan = settting.filters['isVegan']!.obs;
    RxBool isLactoseFree = settting.filters['isLactoseFree']!.obs;

    void setFilters() {
      final Map<String, bool> newFilters = {
        'isGlutenFree': isGlutenFree.value,
        'isVegan': isVegan.value,
        'isLactoseFree': isLactoseFree.value,
      };
      settting.setfilters(newFilters, context);
    }

    final screenSize = MediaQuery.sizeOf(context);

    //border
    return Container(
      margin: const EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(65),
        color: Colors.deepPurpleAccent[400],
      ),
      //content
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          margin: const EdgeInsets.all(0.75),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Get.theme.colorScheme.background),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //________________________________________________________________________ gluent
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gluten free',
                    style: TextStyle(
                      fontSize: screenSize.height * 0.3 / 4 * 0.4,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3 * 0.2,
                    width: MediaQuery.of(context).size.width * 0.9 * 0.05,
                    child: FittedBox(
                      child: GetBuilder<UserController>(
                        id: "filters",
                        builder: (setting) => Switch.adaptive(
                          activeColor:
                              Get.theme.primaryColor.withOpacity(0.8),
                          value: isGlutenFree.value,
                          onChanged: (val) {
                            isGlutenFree.value = val;
                            setFilters();
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
              //________________________________________________________________________ Vagan
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Vegan',
                    style: TextStyle(
                      fontSize: screenSize.height * 0.3 / 4 * 0.4,
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.3 * 0.2,
                    width: screenSize.width * 0.9 * 0.05,
                    child: FittedBox(
                      child: GetBuilder<UserController>(
                        id: "filters",
                        builder: (setting) => Switch.adaptive(
                          activeColor:
                              Get.theme.primaryColor.withOpacity(0.8),
                          value: isVegan.value,
                          onChanged: (val) {
                            isVegan.value = val;
                            setFilters();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //________________________________________________________________________ Lactos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Lactos free',
                    style: TextStyle(
                      fontSize: screenSize.height * 0.3 / 4 * 0.4,
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.3 * 0.2,
                    width: screenSize.width * 0.9 * 0.05,
                    child: FittedBox(
                      child: GetBuilder<UserController>(
                        id: "filters",
                        builder: (setting) => Switch.adaptive(
                          activeColor:
                              Get.theme.primaryColor.withOpacity(0.8),
                          value: isLactoseFree.value,
                          onChanged: (val) {
                            isLactoseFree.value = val;
                            setFilters();
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class IngredientsChoice extends StatefulWidget {
  const IngredientsChoice({Key? key}) : super(key: key);

  @override
  State<IngredientsChoice> createState() => _IngredientsChoiceState();
}

class _IngredientsChoiceState extends State<IngredientsChoice> {
  List<String> _foundCats = Get.find<FoodController>().availableCategories;

  // textField
  final _searchtext = TextEditingController();
  final _focus = FocusNode();
  bool _hasFocus = false;

  @override
  Widget build(BuildContext context) {
    final foodCtrl = Get.find<FoodController>();
    _searchtext.addListener(() {
      setState(() {
        if (_searchtext.text.isEmpty) {
          _foundCats = foodCtrl.availableCategories;
        } else {
          _foundCats = foodCtrl.catrgorySearch(text: _searchtext.text);
        }
      });
    });
    _focus.addListener(() async {
      if (!_focus.hasFocus) {
        await Future.delayed(const Duration(milliseconds: 300));
      }
      setState(() {
        _hasFocus = _focus.hasFocus;
      });
    });
    //
    return GetBuilder<UserController>(
        id: "userCats",
        builder: (user) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // label
              Text(
                "Categories",
                style: Get.theme.textTheme.bodySmall,
              ),
              // search
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  focusNode: _focus,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  style: Get.theme.textTheme.bodySmall,
                  controller: _searchtext,
                ),
              ),
              // list
              Expanded(
                child: Obx(
                  () => Column(children: [
                    _hasFocus
                        ? _foundCats.isEmpty
                            ? Text("No item Found",
                                style: Get.theme.textTheme.bodySmall)

                            // found cats list
                            : Expanded(
                                child: ListView.builder(
                                  itemCount: _foundCats.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      key: UniqueKey(),
                                      onTap: () {
                                        // put if absent
                                        user.addCatergory(_foundCats[index]);
                                      },
                                      leading: CircleAvatar(
                                          backgroundColor:
                                              Get.theme.primaryColor),
                                      title: Text(
                                        _foundCats[index],
                                        style: Get.theme
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    );
                                  },
                                ),
                              )

                        // food cats
                        : Expanded(
                            child: ListView(
                            scrollDirection: Axis.vertical,
                            children: List.generate(
                                user.selectedCategories.length, (index) {
                              return Padding(
                                padding:
                                    EdgeInsets.only(top: index == 0 ? 0 : 8.0),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    key: UniqueKey(),
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // remove cat
                                      IconButton(
                                        onPressed: () {
                                          user.removeCatergory(
                                              user.selectedCategories[index]);
                                        },
                                        icon: const Icon(Icons.clear,
                                            color: Colors.black),
                                      ),
                                      // name
                                      Text(
                                        user.selectedCategories[index],
                                        style: Get.theme
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          )),
                  ]),
                ),
              )
            ],
          );
        });
  }
}
