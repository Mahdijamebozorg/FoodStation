import 'package:FoodApp/Providers/Settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:FoodApp/models/meal.dart';

class Mealscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Settings settings = Provider.of<Settings>(context, listen: false);
    final Size screenSize = settings.screenSize(context);
    final bool islandscape = settings.islandscape(context);
    //routes
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map;
    final Meal selectedmeal = routeArgs['Meal'];

    ///body
    return Scaffold(
      appBar: AppBar(
        actions: [
          //Starbutton
          //only this part will be updated if chnages because of consumer
          Consumer<Settings>(
            builder: (cntx, setting, child) => IconButton(
                onPressed: () {
                  if (settings.favoriteMeals.contains(selectedmeal)) {
                    settings.removeFavoriteMeal(selectedmeal);
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: Duration(seconds: 1),
                        backgroundColor: Theme.of(context).primaryColor,
                        content: Text(
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
                        duration: Duration(seconds: 1),
                        backgroundColor: Theme.of(context).primaryColor,
                        content: Text(
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
          SizedBox(
            width: 10,
          ),
        ],
        title: Text(selectedmeal.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            //image
            Container(
              width: islandscape ? screenSize.width * 0.8 : double.infinity,
              child: Image.asset(
                selectedmeal.imageUrl,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'ingridients:',
                style: Theme.of(context).textTheme.bodyText1,
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
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
                itemCount: selectedmeal.ingredients.length,
              ),
            ),
            //steps
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Steps:',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Container(
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
                    contentPadding: EdgeInsets.all(15),
                  ),
                  //Divide listTile
                  Divider()
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
