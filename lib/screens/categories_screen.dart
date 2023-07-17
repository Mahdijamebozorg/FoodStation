import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:FoodApp/Providers/Settings.dart';
import '../widgets/category_item.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Settings setting = Provider.of<Settings>(context, listen: false);
    return Consumer<Settings>(
      builder: (_, setting, staticChild) {
        final screenwidth = setting.screenSize(context).width;
        final islandscape = setting.islandscape(context);
        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, index) =>
              CategoryItem(setting.availableCategories[index]),
          itemCount: setting.availableCategories.length,
          //Gridview options
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            //Width
            maxCrossAxisExtent: islandscape ? screenwidth / 4 : screenwidth / 2,
            //Width / Height
            childAspectRatio: 4 / 3,
            //فاصله عمودی
            mainAxisSpacing: 20,
            //فاصله افقی
            crossAxisSpacing: 20,
          ),
        );
      },
    );
  }
}
