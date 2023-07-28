import 'package:food_app/View/widgets/drawer.dart';
import 'package:food_app/View/widgets/filters.dart';
import 'package:flutter/material.dart';

class SettingScreeen extends StatelessWidget {
  static const routeName = '/Setting';
  const SettingScreeen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
