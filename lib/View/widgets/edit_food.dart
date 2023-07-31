import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_app/Controller/settings.dart';
import 'package:food_app/Model/food.dart';
import 'package:food_app/Model/ingridient.dart';
import 'package:get/get.dart';

Rx<Food> _food = Food.dummy.obs;

class EditFood extends StatefulWidget {
  final Food? food;
  const EditFood({this.food, Key? key}) : super(key: key);

  @override
  State<EditFood> createState() => _EditFoodState();
}

class _EditFoodState extends State<EditFood> {
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    // if editing food
    if (widget.food != null) {
      _food.value = widget.food!;
    }
    super.initState();
  }

  void _saveData() {
    // validate
    bool isValid = _form.currentState!.validate();
    if (!isValid) return;

    // remove steps because we are adding all
    _food.value = Food.updateFood(food: _food.value, steps: []);

    // apply changes
    _form.currentState!.save();

    final settings = Get.find<Settings>();

    // if new food
    if (widget.food == null) {
      settings.addFood(_food.value);
    } else {
      settings.updateFood(id: widget.food!.id, newfood: _food.value);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // background
        return Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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
                            Expanded(child: StepsView()),

                            const SizedBox(width: 20.0),

                            SizedBox(
                              width: constraints.maxWidth * 0.6,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Categories, Ingridients
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(child: IngridientsChoice()),
                                        const SizedBox(width: 20.0),
                                        Expanded(child: CategoriesChoice()),
                                      ],
                                    ),
                                  ),
                                  // complexity, affordability
                                  const Row(
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
                onPressed: _saveData,
                child: const Text("Save"),
              )
            ],
          ),
        );
      },
    );
  }
}

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
              style: Theme.of(context).textTheme.bodySmall,
              initialValue: _food.value.title,
              decoration: InputDecoration(
                labelText: 'Title',
                errorStyle: TextStyle(color: Colors.red[800], fontSize: 12),
                floatingLabelStyle: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 14),
                hintStyle: Theme.of(context).textTheme.bodySmall,
                labelStyle: Theme.of(context).textTheme.bodySmall,
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
                _food.value = Food.updateFood(
                  food: _food.value,
                  title: newValue,
                );
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
                _food.value = Food.updateFood(
                  food: _food.value,
                  duration: int.parse(newValue!),
                );
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
                _food.value = Food.updateFood(
                  food: _food.value,
                  imageUrl: newValue,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class Switches extends StatelessWidget {
  const Switches({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              Text("Gluten free", style: Theme.of(context).textTheme.bodySmall),
              Switch.adaptive(
                value: _food.value.isGlutenFree,
                onChanged: (value) {
                  _food.value = Food.updateFood(
                    food: _food.value,
                    isGlutenFree: value,
                  );
                },
              ),
            ],
          ),
          Row(
            children: [
              Text("Lactose free",
                  style: Theme.of(context).textTheme.bodySmall),
              Switch.adaptive(
                value: _food.value.isLactoseFree,
                onChanged: (value) {
                  _food.value = Food.updateFood(
                    food: _food.value,
                    isLactoseFree: value,
                  );
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
                  _food.value = Food.updateFood(
                    food: _food.value,
                    isVegan: value,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class StepsView extends StatelessWidget {
  StepsView({Key? key}) : super(key: key);

  final RxList<String> _steps = RxList(_food.value.steps);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: Obx(
            () => ListView.builder(
              itemCount: _steps.length,
              itemBuilder: (context, index) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // remove step
                  IconButton(
                    onPressed: () {
                      _steps.remove(_steps[index]);
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  Flexible(
                    child: TextFormField(
                      maxLines: 3,
                      style: Theme.of(context).textTheme.bodySmall,
                      initialValue: _steps[index],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      // add step
                      onSaved: (value) {
                        var copy = _food.value.steps;
                        copy.add(value!);
                        _food.value =
                            Food.updateFood(food: _food.value, steps: copy);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        TextButton.icon(
          onPressed: () {
            var copy = _steps;
            copy.add("");
            _food.value = Food.updateFood(food: _food.value, steps: copy);
          },
          icon: const Icon(Icons.add),
          label: const Text("Add Step"),
        )
      ],
    );
  }
}

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
        _food.value = Food.updateFood(
          food: _food.value,
          complexity: newVal,
        );
      },
    );
  }
}

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
        _food.value = Food.updateFood(
          food: _food.value,
          affordability: newVal,
        );
      },
    );
  }
}

class IngridientsChoice extends StatelessWidget {
  IngridientsChoice({Key? key}) : super(key: key);

  final _searchtext = TextEditingController();
  final RxString _text = "".obs;
  final RxList<Ingridient> _foundIngs = RxList<Ingridient>();
  final settings = Get.find<Settings>();
  final _focus = FocusNode();
  final RxBool _hasFocus = false.obs;

  @override
  Widget build(BuildContext context) {
    _foundIngs.value = settings.availableIngridient;
    _searchtext.addListener(() {
      _text.value = _searchtext.text;
      if (_text.isEmpty) {
        _foundIngs.value = settings.availableIngridient;
      } else {
        _foundIngs.value = settings.ingridientSearch(text: _searchtext.text);
      }
    });
    _focus.addListener(() async {
      if (!_focus.hasFocus) {
        await Future.delayed(const Duration(milliseconds: 300));
      }
      _hasFocus.value = _focus.hasFocus;
    });
    //
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // label
        Text(
          "Ingridients",
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
              _hasFocus.value
                  ? _foundIngs.isEmpty
                      ? Text("No item Found",
                          style: Theme.of(context).textTheme.bodySmall)
                      : Expanded(
                          child: ListView.builder(
                            itemCount: _foundIngs.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  var copyIngs = _food.value.ingredients;
                                  // put if absent
                                  copyIngs.addIf(
                                      !_food.value.ingredients
                                          .contains(_foundIngs[index].name),
                                      _foundIngs[index].name);
                                  _food.value = Food.updateFood(
                                      food: _food.value, ingredients: copyIngs);
                                },
                                leading: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).primaryColor),
                                title: Text(
                                  _foundIngs[index].name,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              );
                            },
                          ),
                        )
                  : Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _food.value.ingredients.length,
                        itemBuilder: (context, index) => Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                var copyIngs = _food.value.ingredients;
                                copyIngs.remove(_food.value.ingredients[index]);
                                _food.value = Food.updateFood(
                                  food: _food.value,
                                  ingredients: copyIngs,
                                );
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              _food.value.ingredients[index],
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
            ]),
          ),
        )
      ],
    );
  }
}

class CategoriesChoice extends StatelessWidget {
  CategoriesChoice({Key? key}) : super(key: key);

  final settings = Get.find<Settings>();
  final RxInt _currentItem = 0.obs;

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
                  child: InkWell(
                    // add cat
                    onTap: () {
                      var copyCats = _food.value.categories;
                      // put if absent
                      copyCats.addIf(
                          // TODO remove .id
                          !_food.value.categories.contains(settings
                              .availableCategories[_currentItem.value].id),
                          settings.availableCategories[_currentItem.value].id);
                      _food.value = Food.updateFood(
                          food: _food.value, categories: copyCats);
                    },
                    child: ListWheelScrollView(
                      onSelectedItemChanged: (value) {
                        _currentItem.value = value;
                      },
                      diameterRatio: 0.6,
                      itemExtent: 30,
                      children: List.generate(
                        settings.availableCategories.length,
                        (index) => Container(
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
                            settings.availableCategories[index].title,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _food.value.categories.length,
                    itemBuilder: (context, index) => ListTile(
                      tileColor: Theme.of(context).primaryColor,
                      title: Text(
                        _food.value.categories[index],
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      leading: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // remove cat
                          var copyCats = _food.value.categories;
                          copyCats.remove(_food.value.categories[index]);
                          _food.value = Food.updateFood(
                              food: _food.value, categories: copyCats);
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

// class FiltersView extends StatelessWidget {
//   IngridientsChoice({Key? key}) : super(key: key);

//   final _searchtext = TextEditingController();
//   final RxString _text = "".obs;
//   final RxList<Ingridient> _foundIngs = RxList<Ingridient>();
//   final settings = Get.find<Settings>();
//   final _focus = FocusNode();
//   final RxBool _hasFocus = false.obs;

//   @override
//   Widget build(BuildContext context) {
//     _foundIngs.value = settings.availableIngridient;
//     _searchtext.addListener(() {
//       _text.value = _searchtext.text;
//       if (_text.isEmpty) {
//         _foundIngs.value = settings.availableIngridient;
//       } else {
//         _foundIngs.value = settings.ingridientSearch(text: _searchtext.text);
//       }
//     });
//     _focus.addListener(() async {
//       if (!_focus.hasFocus) {
//         await Future.delayed(const Duration(milliseconds: 300));
//       }
//       _hasFocus.value = _focus.hasFocus;
//     });
//     //
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         // label
//         Text(
//           "Ingridients",
//           style: Theme.of(context).textTheme.bodySmall,
//         ),
//         // search
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: TextField(
//             focusNode: _focus,
//             decoration: InputDecoration(
//               border:
//                   OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
//             ),
//             style: Theme.of(context).textTheme.bodySmall,
//             controller: _searchtext,
//           ),
//         ),
//         // list
//         Expanded(
//           child: Obx(
//             () => Column(children: [
//               _hasFocus.value
//                   ? _foundIngs.isEmpty
//                       ? Text("No item Found",
//                           style: Theme.of(context).textTheme.bodySmall)
//                       : Expanded(
//                           child: ListView.builder(
//                             itemCount: _foundIngs.length,
//                             itemBuilder: (context, index) {
//                               return ListTile(
//                                 onTap: () {
//                                   var copyIngs = _food.value.ingredients;
//                                   // put if absent
//                                   copyIngs.addIf(
//                                       !_food.value.ingredients
//                                           .contains(_foundIngs[index].name),
//                                       _foundIngs[index].name);
//                                   _food.value = Food.updateFood(
//                                       food: _food.value, ingredients: copyIngs);
//                                 },
//                                 leading: CircleAvatar(
//                                     backgroundColor:
//                                         Theme.of(context).primaryColor),
//                                 title: Text(
//                                   _foundIngs[index].name,
//                                   style: Theme.of(context).textTheme.bodySmall,
//                                 ),
//                               );
//                             },
//                           ),
//                         )
//                   : Expanded(
//                       child: ListView.builder(
//                         scrollDirection: Axis.horizontal,
//                         itemCount: _food.value.ingredients.length,
//                         itemBuilder: (context, index) => Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton(
//                               onPressed: () {
//                                 var copyIngs = _food.value.ingredients;
//                                 copyIngs
//                                     .remove(_food.value.ingredients[index]);
//                                 _food.value = Food.updateFood(
//                                   food: _food.value,
//                                   ingredients: copyIngs,
//                                 );
//                               },
//                               icon: const Icon(
//                                 Icons.delete,
//                                 color: Colors.red,
//                               ),
//                             ),
//                             Text(
//                               _food.value.ingredients[index],
//                               style: Theme.of(context).textTheme.bodySmall,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//             ]),
//           ),
//         )
//       ],
//     );
//   }
// }