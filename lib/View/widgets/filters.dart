import 'package:flutter/material.dart';
import 'package:food_app/Controller/settings.dart';
import 'package:get/get.dart';

class Filters extends StatelessWidget {
  static const routeName = "/Filters";

  const Filters({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Settings settting = Get.find<Settings>();

    //filters setted in setting
    RxBool isGlutenFree = settting.filters['_isGlutenFree']!.obs;
    RxBool isVegan = settting.filters['_isVegan']!.obs;
    RxBool isVegetarian = settting.filters['_isVegetarian']!.obs;
    RxBool isLactoseFree = settting.filters['_isLactoseFree']!.obs;

    void setFilters() {
      final Map<String, bool> newFilters = {
        '_isGlutenFree': isGlutenFree.value,
        '_isVegan': isVegan.value,
        '_isVegetarian': isVegetarian.value,
        '_isLactoseFree': isLactoseFree.value,
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
              color: Theme.of(context).colorScheme.background),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //________________________________________________________________________ gluent
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'GlutenFree',
                    style: TextStyle(
                      fontSize: screenSize.height * 0.3 / 4 * 0.4,
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3 * 0.2,
                    width: MediaQuery.of(context).size.width * 0.9 * 0.05,
                    child: FittedBox(
                      child: GetBuilder<Settings>(
                        id: "filters",
                        builder: (setting) => Switch.adaptive(
                          activeColor:
                              Theme.of(context).primaryColor.withOpacity(0.8),
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
                      child: GetBuilder<Settings>(
                        id: "filters",
                        builder: (setting) => Switch.adaptive(
                          activeColor:
                              Theme.of(context).primaryColor.withOpacity(0.8),
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
              //________________________________________________________________________ Vageterian
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Vageterian',
                    style: TextStyle(
                      fontSize: screenSize.height * 0.3 / 4 * 0.4,
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.3 * 0.2,
                    width: screenSize.width * 0.9 * 0.05,
                    child: FittedBox(
                      child: GetBuilder<Settings>(
                        id: "filters",
                        builder: (setting) => Switch.adaptive(
                          activeColor:
                              Theme.of(context).primaryColor.withOpacity(0.8),
                          value: isVegetarian.value,
                          onChanged: (val) {
                            isVegetarian.value = val;
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
                    'Lactosfree',
                    style: TextStyle(
                      fontSize: screenSize.height * 0.3 / 4 * 0.4,
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.3 * 0.2,
                    width: screenSize.width * 0.9 * 0.05,
                    child: FittedBox(
                      child: GetBuilder<Settings>(
                        id: "filters",
                        builder: (setting) => Switch.adaptive(
                          activeColor:
                              Theme.of(context).primaryColor.withOpacity(0.8),
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
