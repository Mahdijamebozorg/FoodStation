import 'package:FoodApp/widgets/Drawer.dart';
import 'package:FoodApp/widgets/Filters.dart';
import 'package:flutter/material.dart';

class SettingScreeen extends StatefulWidget {
  static const routeName = '/setting';

  @override
  _SettingScreeenState createState() => _SettingScreeenState();
}

class _SettingScreeenState extends State<SettingScreeen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
      ),
      //body
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: ListView(
          children: [
            FittedBox(child: Filters()),
          ],
        ),
      ),
      drawer: Drwer(),
      drawerEdgeDragWidth: 160,
    );
  }
}
