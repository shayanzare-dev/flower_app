import 'package:flower_app/src/pages/vendor_home_page/view/widget/search_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/vendor_home_page_flower_controller.dart';
import 'flower_item.dart';

class SearchScreen extends GetView<VendorHomePageFlowerController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: controller.searchController,
            onChanged: (value) {
              controller.searchFlowers(value);
            },
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    controller.clearFilteredFlowerList();
                  },
                ),
                labelText: 'Search or for filter press search icon',
                prefixIcon: SearchAlertDialog()),
          ),
          SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.filteredFlowerList.length,
                itemBuilder: (final context, final index) => FlowerItem(
                    flowerItem: controller.filteredFlowerList[index]),
              );
            }),
          ),
        ],
      ),
    );
  }
}
