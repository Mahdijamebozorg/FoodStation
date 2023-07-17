import 'package:FoodApp/Providers/Settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Drwer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize =
        Provider.of<Settings>(context, listen: false).screenSize(context);

    return Drawer(
      //main container
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: screenSize.height * 0.9,
              child: ListView(
                children: [
                  //top container
                  Container(
                    width: double.infinity,
                    height: screenSize.height * 0.2,
                    color: Colors.pink[600],
                    child: Card(
                      margin: EdgeInsets.all(20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                  //Meals
                  ListTile(
                    title: Row(children: [
                      Icon(
                        Icons.restaurant,
                        color: Colors.black54,
                        size: 36,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Meals'),
                    ]),
                    onTap: () =>
                        Navigator.of(context).pushReplacementNamed('/'),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.03,
                  ),
                  //Filters
                  ListTile(
                    title: Row(children: [
                      Icon(
                        Icons.health_and_safety_sharp,
                        color: Colors.black54,
                        size: 40,
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Text('Health Center'),
                    ]),
                    // onTap: () =>
                    //     Navigator.of(context).pushReplacementNamed('/DRpage'),
                  ),
                ],
              ),
            ),
            //Settings
            Container(
              height: screenSize.height * 0.1,
              child: ListTile(
                title: Row(children: [
                  Icon(
                    Icons.settings_applications,
                    color: Colors.black54,
                    size: 40,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text('Settings'),
                ]),
                onTap: () =>
                    Navigator.of(context).pushReplacementNamed('/setting'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
