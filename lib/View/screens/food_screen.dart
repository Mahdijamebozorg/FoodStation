import 'package:FoodApp/Controller/settings.dart';
import 'package:flutter/material.dart';
import 'package:FoodApp/Model/meal.dart';
import 'package:get/get.dart';

class FoodScreen extends StatelessWidget {
  const FoodScreen({Key? key}) : super(key: key);
  static const routeName = "/foodScreen";

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.sizeOf(context);
    final bool islandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    //routes
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    final Meal selectedmeal = routeArgs['Meal'];

    ///body
    return Scaffold(
      appBar: AppBar(
        actions: [
          //Starbutton
          //only this part will be updated if chnages because of consumer
          GetBuilder<Settings>(
            id: "favs",
            builder: (Settings settings) => IconButton(
                onPressed: () {
                  if (settings.favoriteMeals.contains(selectedmeal)) {
                    settings.removeFavoriteMeal(selectedmeal);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 1),
                        backgroundColor: Theme.of(context).primaryColor,
                        content: const Text(
                          "Removed from favorites",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  } else {
                    settings.addFavoriteMeal(selectedmeal);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(seconds: 1),
                        backgroundColor: Theme.of(context).primaryColor,
                        content: const Text(
                          "Added to favorites",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }
                },
                icon: Icon(
                  Icons.star,
                  color: settings.favoriteMeals.contains(selectedmeal)
                      ? Colors.yellow
                      : Colors.grey,
                  size: 30,
                )),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
        title: Text(selectedmeal.title),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            //image
            SizedBox(
              width: islandscape ? screenSize.width * 0.8 : double.infinity,
              child: Image.asset(
                selectedmeal.imageUrl,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'ingridients:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            //ingridients
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.black)),
              height: 150,
              width: 300,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.pink,
                    child: Text(
                      selectedmeal.ingredients[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
                itemCount: selectedmeal.ingredients.length,
              ),
            ),
            //steps
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                'Steps:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            SizedBox(
              width: screenSize.width * 0.75,
              height: 300,
              child: ListView.builder(
                itemBuilder: (context, index) => Column(children: [
                  ListTile(
                    leading: CircleAvatar(
                      child: Text('# ${index + 1}'),
                    ),
                    title: Text(selectedmeal.steps[index]),
                    tileColor: Colors.purple[800],
                    contentPadding: const EdgeInsets.all(15),
                  ),
                  //Divide listTile
                  const Divider()
                ]),
                itemCount: selectedmeal.steps.length,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
