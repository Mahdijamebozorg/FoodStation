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
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: ListView(
            children: const [
              FittedBox(child: Filters()),
            ],
          ),
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
                      child: GetBuilder<UserController>(
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
