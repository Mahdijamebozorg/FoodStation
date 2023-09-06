import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_app/Controller/food_controller.dart';
import 'package:food_app/Model/food.dart';
import 'package:food_app/View/widgets/food_item.dart';
import 'package:get/get.dart';

Rx<Food> _food = Food.dummy.obs;
RxList<Food> _foundFoods = RxList();
bool _isAffordNull = true;
bool _isComplexNull = true;

class AdvancedSearch extends StatelessWidget {
  AdvancedSearch({Key? key}) : super(key: key);
  static const routeName = "/advancedSearch";

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void saveData() {
      // apply text changes

      _form.currentState!.save();

      final foodCtrl = Get.find<FoodController>();

      _foundFoods.value = foodCtrl.availableFoods.where((food) {
        bool hasCats = true;
        if (_food.value.categories.isNotEmpty) {
          hasCats = false;
          for (var cat in _food.value.categories) {
            if (food.categories.contains(cat)) {
              hasCats = true;
              break;
            }
          }
        }

        bool hasIngs = true;
        if (_food.value.ingredients.isNotEmpty) {
          hasIngs = false;
          // search in selected ings
          for (var ing in _food.value.ingredients) {
            for (var key in ing.keys) {
              // check if food has this ing
              for (var foodIng in food.ingredients) {
                if (foodIng.keys.contains(key)) {
                  hasIngs = true;
                  break;
                }
              }
            }
          }
        }

        bool hasComplexity =
            _isComplexNull ? true : _food.value.complexity == food.complexity;

        bool hasAffordability = _isAffordNull
            ? true
            : _food.value.affordability == food.affordability;

        bool hasLactoseFree =
            (_food.value.isLactoseFree) ? food.isLactoseFree : true;

        bool hasGlutenFree =
            (_food.value.isGlutenFree) ? food.isGlutenFree : true;

        bool vegan = (_food.value.isVegan) ? food.isVegan : true;

        bool hasTitle = (_food.value.title.isNotEmpty)
            ? food.title.contains(_food.value.title)
            : true;

        bool hasDuration = (_food.value.duration != 0)
            ? food.duration == _food.value.duration
            : true;

        return
            // complexity
            hasComplexity &&
                // affordability
                hasAffordability &&
                // lactose
                hasLactoseFree &&
                // gluten
                hasGlutenFree &&
                // vegan
                vegan &&
                // title
                hasTitle &&
                // duration
                hasDuration &&
                // categories
                hasCats &&
                // ingredients
                hasIngs;
      }).toList();
    }

    return GetBuilder<FoodController>(
        id: "foods",
        builder: (foodCtrl) {
          return Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                // background
                return Container(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Get.theme.scaffoldBackgroundColor,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 500,
                          width: constraints.maxWidth,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // input data
                              Expanded(
                                child: Form(
                                  key: _form,
                                  child: const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // title, duration, imageUrl
                                      TextInputs(),

                                      Divider(height: 20),

                                      // filters: isGlutenFree, isLactoseFree, isVegan
                                      Switches(),

                                      Divider(height: 20),

                                      // last row
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Flexible(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                      child:
                                                          AffordablilityView()),
                                                  Expanded(
                                                      child: ComplexityView()),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 20.0),
                                            Expanded(
                                                child: IngredientsChoice()),
                                            SizedBox(width: 20.0),
                                            Expanded(child: CategoriesChoice())
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30.0),
                              // save button
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: saveData,
                                    child: const Text("Search"),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _food.value = Food.dummy;
                                      _foundFoods.clear();
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Exit"),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        SizedBox(
                          height: constraints.maxHeight * 0.5,
                          child: const FoodsGrid(),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        });
  }
}

//_____________________
class TextInputs extends StatelessWidget {
  const TextInputs({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FocusNode duration = FocusNode();
    final FocusNode imageUrl = FocusNode();
    return Row(
      children: [
        // title
        Flexible(
          child: Container(
            padding:
                const EdgeInsets.only(bottom: 8.0, right: 12.0, left: 12.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(color: Colors.black54),
            ),
            child: TextFormField(
              cursorHeight: 24,
              maxLength: 50,
              style: Get.theme.textTheme.bodySmall,
              initialValue: _food.value.title,
              decoration: InputDecoration(
                labelText: 'Title',
                errorStyle: TextStyle(color: Colors.red[800], fontSize: 12),
                floatingLabelStyle: TextStyle(
                    color: Get.theme.primaryColor, fontSize: 14),
                hintStyle: Get.theme.textTheme.bodySmall,
                labelStyle: Get.theme.textTheme.bodySmall,
                counterStyle: TextStyle(
                    fontSize: 8, color: Get.theme.primaryColor),
              ),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) =>
                  FocusScope.of(context).requestFocus(duration),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please provide a value.';
                }
                return null;
              },
              onSaved: (newValue) {
                _food.value.title = newValue ?? "";
              },
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        // duration
        Flexible(
          child: Container(
            padding:
                const EdgeInsets.only(bottom: 8.0, right: 12.0, left: 12.0),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(color: Colors.black54),
            ),
            child: TextFormField(
              cursorHeight: 24,
              maxLength: 3,
              style: Get.theme.textTheme.bodySmall,
              focusNode: duration,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              initialValue: _food.value.duration == 0
                  ? null
                  : _food.value.duration.toString(),
              decoration: InputDecoration(
                labelText: 'Duration',
                errorStyle: TextStyle(color: Colors.red[800], fontSize: 12),
                floatingLabelStyle: TextStyle(
                    color: Get.theme.primaryColor, fontSize: 14),
                hintStyle: Get.theme.textTheme.bodySmall,
                labelStyle: Get.theme.textTheme.bodySmall,
                counterStyle: TextStyle(
                    fontSize: 8, color: Get.theme.primaryColor),
              ),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) =>
                  FocusScope.of(context).requestFocus(imageUrl),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please provide a value.';
                }
                return null;
              },
              onSaved: (newValue) {
                _food.value.duration = newValue == null || newValue.isEmpty
                    ? 0
                    : int.parse(newValue);
              },
            ),
          ),
        ),
      ],
    );
  }
}

//_____________________
class Switches extends StatefulWidget {
  const Switches({Key? key}) : super(key: key);

  @override
  State<Switches> createState() => _SwitchesState();
}

class _SwitchesState extends State<Switches> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          children: [
            Text("Gluten free", style: Get.theme.textTheme.bodySmall),
            Switch.adaptive(
              value: _food.value.isGlutenFree,
              onChanged: (value) {
                setState(() {
                  _food.value.isGlutenFree = value;
                });
              },
            ),
          ],
        ),
        Row(
          children: [
            Text("Lactose free", style: Get.theme.textTheme.bodySmall),
            Switch.adaptive(
              value: _food.value.isLactoseFree,
              onChanged: (value) {
                setState(() {
                  _food.value.isLactoseFree = value;
                });
              },
            ),
          ],
        ),
        Row(
          children: [
            Text("Vegan", style: Get.theme.textTheme.bodySmall),
            Switch.adaptive(
              value: _food.value.isVegan,
              onChanged: (value) {
                setState(() {
                  _food.value.isVegan = value;
                });
              },
            ),
          ],
        ),
      ],
    );
  }
}

//_____________________
class ComplexityView extends StatelessWidget {
  const ComplexityView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Complexity?>(
      dropdownColor: Get.theme.primaryColor,
      style: Get.theme.textTheme.bodySmall,
      value: _isComplexNull ? null : _food.value.complexity,
      items: const [
        DropdownMenuItem(
          value: null,
          child: Text(""),
        ),
        DropdownMenuItem(
          value: Complexity.simple,
          child: Text("Simple"),
        ),
        DropdownMenuItem(
          value: Complexity.challenging,
          child: Text("Challenging"),
        ),
        DropdownMenuItem(
          value: Complexity.hard,
          child: Text("Hard"),
        ),
      ],
      onChanged: (newVal) {},
      onSaved: (newVal) {
        if (newVal == null) {
          _isComplexNull = true;
        } else {
          _food.value.complexity = newVal;
          _isComplexNull = false;
        }
      },
    );
  }
}

//_____________________
class AffordablilityView extends StatelessWidget {
  const AffordablilityView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<Affordability?>(
      dropdownColor: Get.theme.primaryColor,
      style: Get.theme.textTheme.bodySmall,
      value: _isAffordNull ? null : _food.value.affordability,
      items: const [
        DropdownMenuItem(
          value: null,
          child: Text(""),
        ),
        DropdownMenuItem(
          value: Affordability.affordable,
          child: Text("Affordable"),
        ),
        DropdownMenuItem(
          value: Affordability.pricey,
          child: Text("Pricey"),
        ),
        DropdownMenuItem(
          value: Affordability.luxurious,
          child: Text("Luxurious"),
        ),
      ],
      onChanged: (newVal) {},
      onSaved: (newVal) {
        if (newVal == null) {
          _isAffordNull = true;
        } else {
          _food.value.affordability = newVal;
          _isAffordNull = false;
        }
      },
    );
  }
}

//_____________________
class IngredientsChoice extends StatefulWidget {
  const IngredientsChoice({Key? key}) : super(key: key);

  @override
  State<IngredientsChoice> createState() => _IngredientsChoiceState();
}

class _IngredientsChoiceState extends State<IngredientsChoice> {
  List<String> _foundIngs = Get.find<FoodController>().availableIngredientNames;

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
          _foundIngs = foodCtrl.availableIngredientNames;
        } else {
          _foundIngs = foodCtrl.ingredientSearch(text: _searchtext.text);
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // label
        Text(
          "Ingredients",
          style: Get.theme.textTheme.bodySmall,
        ),
        // search
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            focusNode: _focus,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
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
                  ? _foundIngs.isEmpty
                      ? Text("No item Found",
                          style: Get.theme.textTheme.bodySmall)

                      // found ings list
                      : Expanded(
                          child: ListView.builder(
                            itemCount: _foundIngs.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                key: UniqueKey(),
                                onTap: () {
                                  // put if absent
                                  setState(() {
                                    _food.value.ingredients.addIf(
                                        !_food.value.getIngredientsNames
                                            .contains(_foundIngs[index]),
                                        {_foundIngs[index]: null});
                                  });
                                },
                                leading: CircleAvatar(
                                    backgroundColor:
                                        Get.theme.primaryColor),
                                title: Text(
                                  _foundIngs[index],
                                  style: Get.theme.textTheme.bodySmall,
                                ),
                              );
                            },
                          ),
                        )

                  // food ings
                  : Expanded(
                      child: ListView(
                      scrollDirection: Axis.vertical,
                      children: List.generate(_food.value.ingredients.length,
                          (index) {
                        return Padding(
                          padding: EdgeInsets.only(top: index == 0 ? 0 : 8.0),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              key: UniqueKey(),
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // remove ing
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _food.value.ingredients.remove(
                                          _food.value.ingredients[index]);
                                    });
                                  },
                                  icon: const Icon(Icons.clear,
                                      color: Colors.black),
                                ),
                                // name
                                Text(
                                  _food.value.getIngredientsNames[index],
                                  style: Get.theme.textTheme.bodySmall,
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
  }
}

//_____________________
class CategoriesChoice extends StatefulWidget {
  const CategoriesChoice({Key? key}) : super(key: key);

  @override
  State<CategoriesChoice> createState() => _CategoriesChoiceState();
}

class _CategoriesChoiceState extends State<CategoriesChoice> {

  @override
  Widget build(BuildContext context) {
    //
    return GetBuilder<FoodController>(
      id: "foods",
      builder: (foodCtrl) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // label
            Text(
              "Categories",
              style: Get.theme.textTheme.bodySmall,
            ),
            // list
            Expanded(
              child: Obx(
                () => Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 150,
                      child: ListWheelScrollView(
                        onSelectedItemChanged: (value) {},
                        diameterRatio: 0.6,
                        itemExtent: 30,
                        children: List.generate(
                          foodCtrl.availableCategories.length,
                          (index) => InkWell(
                            // add category
                            onTap: () {
                              setState(() {
                                _food.value.categories.addIf(
                                    !_food.value.categories.contains(
                                        foodCtrl.availableCategories[index]),
                                    foodCtrl.availableCategories[index]);
                              });
                            },
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Get.theme
                                          .primaryColor
                                          .withOpacity(0.2),
                                      Get.theme.primaryColor
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight),
                                border: Border.all(),
                              ),
                              child: Text(
                                foodCtrl.availableCategories[index],
                                style: Get.theme.textTheme.bodySmall,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: List.generate(
                          _food.value.categories.length,
                          (index) => ListTile(
                            key: UniqueKey(),
                            tileColor: Get.theme.primaryColor,
                            title: Text(
                              _food.value.categories[index],
                              style: Get.theme.textTheme.bodySmall,
                            ),
                            // remove category
                            leading: IconButton(
                              icon: const Icon(Icons.clear, color: Colors.black),
                              onPressed: () {
                                setState(() {
                                  _food.value.categories
                                      .remove(_food.value.categories[index]);
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        );
      }
    );
  }
}

class FoodsGrid extends StatelessWidget {
  const FoodsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GridView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        //gridview options
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
        //items
        itemCount: _foundFoods.length,
        itemBuilder: (ctx, index) => FoodItem(foodId: _foundFoods[index].id),
      );
    });
  }
}
