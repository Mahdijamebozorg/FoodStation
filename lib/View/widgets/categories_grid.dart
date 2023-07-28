import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:FoodApp/Controller/settings.dart';
import 'category_item.dart';

class Categories extends StatelessWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Settings settings = Get.find<Settings>();
    return Obx(
      () {
        final screenwidth = MediaQuery.sizeOf(context).width;
        final islandscape =
            MediaQuery.of(context).orientation == Orientation.landscape;

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemBuilder: (context, index) =>
              CategoryItem(settings.availableCategories[index]),
          itemCount: settings.availableCategories.length,
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
