import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:FoodApp/Providers/Settings.dart';

class Filters extends StatefulWidget {
  static const routeName = "/filters";

  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  @override
  Widget build(BuildContext context) {
    Settings settting = Provider.of<Settings>(context, listen: false);

    //filters setted in setting
    bool _isGlutenFree = settting.filters['_isGlutenFree']!;
    bool _isVegan = settting.filters['_isVegan']!;
    bool _isVegetarian = settting.filters['_isVegetarian']!;
    bool _isLactoseFree = settting.filters['_isLactoseFree']!;

    void setFilters() {
      final Map<String, bool> newFilters = {
        '_isGlutenFree': _isGlutenFree,
        '_isVegan': _isVegan,
        '_isVegetarian': _isVegetarian,
        '_isLactoseFree': _isLactoseFree,
      };
      settting.setfilters(newFilters, context);
    }

    //border
    return Container(
      margin: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(65),
        color: Colors.deepPurpleAccent[400],
      ),
      //content
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          margin: EdgeInsets.all(0.75),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Theme.of(context).backgroundColor),
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
                      fontSize:
                          settting.screenSize(context).height * 0.3 / 4 * 0.4,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3 * 0.2,
                    width: MediaQuery.of(context).size.width * 0.9 * 0.05,
                    child: FittedBox(
                      child: Consumer<Settings>(
                        builder: (_, setting, child) => Switch.adaptive(
                          activeColor: Theme.of(context).primaryColor.withOpacity(0.8),
                          value: _isGlutenFree,
                          onChanged: (val) {
                            _isGlutenFree = val;
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
                      fontSize:
                          settting.screenSize(context).height * 0.3 / 4 * 0.4,
                    ),
                  ),
                  Container(
                    height: settting.screenSize(context).height * 0.3 * 0.2,
                    width: settting.screenSize(context).width * 0.9 * 0.05,
                    child: FittedBox(
                      child: Consumer<Settings>(
                        builder: (_, setting, child) => Switch.adaptive(
                          activeColor: Theme.of(context).primaryColor.withOpacity(0.8),
                          value: _isVegan,
                          onChanged: (val) {
                            _isVegan = val;
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
                      fontSize:
                          settting.screenSize(context).height * 0.3 / 4 * 0.4,
                    ),
                  ),
                  Container(
                    height: settting.screenSize(context).height * 0.3 * 0.2,
                    width: settting.screenSize(context).width * 0.9 * 0.05,
                    child: FittedBox(
                      child: Consumer<Settings>(
                        builder: (_, setting, child) => Switch.adaptive(
                          activeColor: Theme.of(context).primaryColor.withOpacity(0.8),
                          value: _isVegetarian,
                          onChanged: (val) {
                            _isVegetarian = val;
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
                      fontSize:
                          settting.screenSize(context).height * 0.3 / 4 * 0.4,
                    ),
                  ),
                  Container(
                    height: settting.screenSize(context).height * 0.3 * 0.2,
                    width: settting.screenSize(context).width * 0.9 * 0.05,
                    child: FittedBox(
                      child: Consumer<Settings>(
                        builder: (_, setting, child) => Switch.adaptive(
                          activeColor: Theme.of(context).primaryColor.withOpacity(0.8),
                          value: _isLactoseFree,
                          onChanged: (val) {
                            _isLactoseFree = val;
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
