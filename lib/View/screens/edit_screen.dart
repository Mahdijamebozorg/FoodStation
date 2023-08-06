import 'package:flutter/material.dart';
import 'package:food_app/Controller/food_controller.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:food_app/Model/food.dart';

Rx<Food> _food = Food.dummy.obs;

class EditScreen extends StatelessWidget {
  final Food? food;
  EditScreen({this.food, Key? key}) : super(key: key);
  static const routeName = "/editScreen";

  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    bool isEditing = false;
    final routeArgs = Get.arguments as Map?;
    if (food == null) {
      if (routeArgs == null) {
        isEditing = false;
      } else {
        isEditing = true;
        _food.value = routeArgs["food"];
      }
    } else {
      isEditing = true;
      _food.value = food!;
    }

    void saveData() {
      // validate
      bool isValid = _form.currentState!.validate();
      if (!isValid) return;

      // remove steps because we got all
      _food.value.steps = [];

      // apply text changes
      _form.currentState!.save();

      final foodCtrl = Get.find<FoodController>();

      // if new food
      if (isEditing) {
        foodCtrl.updateFood(id: _food.value.id, newfood: _food.value);
      } else {
        foodCtrl.addFood(_food.value);
      }

      // reset data
      _food.value = Food.dummy;

      Navigator.pop(context);
    }

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // background
          return Container(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            // main col
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                // input data
                Expanded(
                  child: Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // title, duration, imageUrl
                        const TextInputs(),

                        const Divider(height: 30),

                        // filters: isGlutenFree, isLactoseFree, isVegan
                        // TODO filters will be expandable too
                        const Switches(),

                        const Divider(height: 30),

                        // last row
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // steps
                              const Expanded(child: StepsView()),

                              const SizedBox(width: 20.0),

                              SizedBox(
                                width: constraints.maxWidth * 0.6,
                                child: const Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Categories, Ingredients
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Expanded(child: CategoryChoice()),
                                          SizedBox(width: 20.0),
                                          Expanded(child: CategoriesChoice()),
                                        ],
                                      ),
                                    ),
                                    // complexity, affordability
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(child: AffordablilityView()),
                                        SizedBox(width: 12.0),
                                        Expanded(child: ComplexityView()),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30.0),
                // save button
                ElevatedButton(
                  onPressed: saveData,
                  child: const Text("Save"),
                )
              ],
            ),
          );
        },
      ),
    );
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
              style: Theme.of(context).textTheme.bodySmall,
              initialValue: _food.value.title,
              decoration: InputDecoration(
                labelText: 'Title',
                errorStyle: TextStyle(color: Colors.red[800], fontSize: 12),
                floatingLabelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 14),
                hintStyle: Theme.of(context).textTheme.bodySmall,
                labelStyle: Theme.of(context).textTheme.bodySmall,
                counterStyle: TextStyle(
                    fontSize: 8, color: Theme.of(context).primaryColor),
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
                _food.value.title = newValue!;
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
              style: Theme.of(context).textTheme.bodySmall,
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
                    color: Theme.of(context).primaryColor, fontSize: 14),
                hintStyle: Theme.of(context).textTheme.bodySmall,
                labelStyle: Theme.of(context).textTheme.bodySmall,
                counterStyle: TextStyle(
                    fontSize: 8, color: Theme.of(context).primaryColor),
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
                _food.value.duration = int.parse(newValue!);
              },
            ),
          ),
        ),
        const SizedBox(width: 8.0),
        // imageUrl
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
              maxLength: 200,
              style: Theme.of(context).textTheme.bodySmall,
              keyboardType: TextInputType.url,
              focusNode: imageUrl,
              initialValue: _food.value.imageUrl,
              decoration: InputDecoration(
                labelText: 'image URL',
                errorStyle: TextStyle(color: Colors.red[800], fontSize: 12),
                floatingLabelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 14),
                hintStyle: Theme.of(context).textTheme.bodySmall,
                labelStyle: Theme.of(context).textTheme.bodySmall,
                counterStyle: TextStyle(
                    fontSize: 8, color: Theme.of(context).primaryColor),
              ),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) => imageUrl.unfocus(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please provide a value.';
                }
                return null;
              },
              onSaved: (newValue) {
                _food.value.imageUrl = newValue!;
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
            Text("Gluten free", style: Theme.of(context).textTheme.bodySmall),
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
            Text("Lactose free", style: Theme.of(context).textTheme.bodySmall),
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
            Text("Vegan", style: Theme.of(context).textTheme.bodySmall),
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
class StepsView extends StatefulWidget {
  const StepsView({Key? key}) : super(key: key);

  @override
  State<StepsView> createState() => _StepsViewState();
}

class _StepsViewState extends State<StepsView> {
  final List<String> _steps =
      _food.value.steps.isEmpty ? ["First Step"] : _food.value.steps;
  @override
  Widget build(BuildContext context) {
    // add an empty step
    return Column(
      children: [
        Flexible(
          child: ListView.builder(
            itemCount: _steps.length,
            itemBuilder: (context, index) => Row(
              key: UniqueKey(),
              mainAxisSize: MainAxisSize.min,
              children: [
                // remove step
                IconButton(
                  onPressed: () {
                    if (_steps.length > 1) {
                      setState(() {
                        _steps.remove(_steps[index]);
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Must have at least one step!"),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                ),
                Flexible(
                  child: TextFormField(
                    maxLength: 200,
                    maxLines: 3,
                    style: Theme.of(context).textTheme.bodySmall,
                    initialValue: _steps[index],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please provide a value.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _steps[index] = value;
                    },
                    // add step
                    onSaved: (value) {
                      _food.value.steps.add(value!);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        // add empty step
        TextButton.icon(
          onPressed: () {
            setState(() {
              _steps.add("");
            });
          },
          icon: const Icon(Icons.add),
          label: const Text("Add Step"),
        )
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
    return DropdownButtonFormField<Complexity>(
      dropdownColor: Theme.of(context).primaryColor,
      style: Theme.of(context).textTheme.bodySmall,
      value: _food.value.complexity,
      items: const [
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
        _food.value.complexity = newVal!;
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
    return DropdownButtonFormField<Affordability>(
      dropdownColor: Theme.of(context).primaryColor,
      style: Theme.of(context).textTheme.bodySmall,
      value: _food.value.affordability,
      items: const [
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
        _food.value.affordability = newVal!;
      },
    );
  }
}

//_____________________
class CategoryChoice extends StatefulWidget {
  const CategoryChoice({Key? key}) : super(key: key);

  @override
  State<CategoryChoice> createState() => _CategoryChoiceState();
}

class _CategoryChoiceState extends State<CategoryChoice> {
  final foodCtrl = Get.find<FoodController>();
  List<String> _foundIngs = Get.find<FoodController>().availableIngredientNames;

  // textField
  final _searchtext = TextEditingController();
  final _focus = FocusNode();
  bool _hasFocus = false;

  bool _hasNotQuentity = true;

  @override
  Widget build(BuildContext context) {
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
          style: Theme.of(context).textTheme.bodySmall,
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
            style: Theme.of(context).textTheme.bodySmall,
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
                          style: Theme.of(context).textTheme.bodySmall)

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
                                        Theme.of(context).primaryColor),
                                title: Text(
                                  _foundIngs[index],
                                  style: Theme.of(context).textTheme.bodySmall,
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
                        // is quantity null
                        _hasNotQuentity = (_food.value.ingredients[index]
                                [_food.value.getIngredientsNames[index]] ==
                            null);

                        // a new obj for null handeling
                        Quantity quantity = _hasNotQuentity
                            ? Quantity(Unit.bottle, 1)
                            : _food.value.ingredients[index]
                                [_food.value.getIngredientsNames[index]]!;

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
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(width: 8.0),
                                // set Unit
                                Flexible(
                                  child: DropdownMenu<Unit?>(
                                    initialSelection:
                                        _hasNotQuentity ? null : quantity.unit,
                                    // hide count if no unit
                                    onSelected: (unit) {
                                      setState(() {
                                        if (unit == null) {
                                          _food.value.ingredients[index][_food
                                                  .value
                                                  .getIngredientsNames[index]] =
                                              null;
                                          _hasNotQuentity = true;
                                        } else {
                                          quantity.unit = unit;
                                          _food.value.ingredients[index][_food
                                                  .value
                                                  .getIngredientsNames[index]] =
                                              quantity;
                                          _hasNotQuentity = false;
                                        }
                                      });
                                    },
                                    dropdownMenuEntries: [
                                      DropdownMenuEntry(
                                        value: null,
                                        label: "Custom",
                                        style: Theme.of(context)
                                            .menuButtonTheme
                                            .style,
                                      ),
                                      DropdownMenuEntry(
                                        value: Unit.bottle,
                                        label: "Bottle",
                                        style: Theme.of(context)
                                            .menuButtonTheme
                                            .style,
                                      ),
                                      DropdownMenuEntry(
                                        value: Unit.grams,
                                        label: "g",
                                        style: Theme.of(context)
                                            .menuButtonTheme
                                            .style,
                                      ),
                                      DropdownMenuEntry(
                                        value: Unit.miliLitre,
                                        label: "mL",
                                        style: Theme.of(context)
                                            .menuButtonTheme
                                            .style,
                                      ),
                                      DropdownMenuEntry(
                                        value: Unit.litre,
                                        label: "L",
                                        style: Theme.of(context)
                                            .menuButtonTheme
                                            .style,
                                      ),
                                      DropdownMenuEntry(
                                        value: Unit.piece,
                                        label: "Piece",
                                        style: Theme.of(context)
                                            .menuButtonTheme
                                            .style,
                                      ),
                                      DropdownMenuEntry(
                                        value: Unit.tableSpoon,
                                        label: "Table Spoon",
                                        style: Theme.of(context)
                                            .menuButtonTheme
                                            .style,
                                      ),
                                      DropdownMenuEntry(
                                        value: Unit.teaSpoon,
                                        label: "Tea Spoon",
                                        style: Theme.of(context)
                                            .menuButtonTheme
                                            .style,
                                      ),
                                    ],
                                  ),
                                ),
                                // get count if has unit
                                if (!_hasNotQuentity)
                                  const SizedBox(width: 8.0),
                                if (!_hasNotQuentity)
                                  SizedBox(
                                    width: 50,
                                    child: TextField(
                                      controller: TextEditingController()
                                        ..text = quantity.count.toString(),
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          quantity.count = double.parse(value);
                                          _food
                                              .value
                                              .ingredients[index][_food.value
                                                  .getIngredientsNames[index]]!
                                              .count = double.parse(value);
                                        }
                                      },
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                      maxLength: 4,
                                      decoration: InputDecoration(
                                        hintText: "count",
                                        counterStyle: TextStyle(
                                            fontSize: 8,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
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
  final foodCtrl = Get.find<FoodController>();

  @override
  Widget build(BuildContext context) {
    //
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // label
        Text(
          "Categories",
          style: Theme.of(context).textTheme.bodySmall,
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
                                  Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.2),
                                  Theme.of(context).primaryColor
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            border: Border.all(),
                          ),
                          child: Text(
                            foodCtrl.availableCategories[index],
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ),
                    // ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _food.value.categories.length,
                    itemBuilder: (context, index) => ListTile(
                      key: UniqueKey(),
                      tileColor: Theme.of(context).primaryColor,
                      title: Text(
                        _food.value.categories[index],
                        style: Theme.of(context).textTheme.bodySmall,
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
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
