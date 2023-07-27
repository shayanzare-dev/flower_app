import 'package:flower_app/src/pages/vendor_home_page/view/widget/bottom_navigation_bar_pages/bottom_navigation_bar_search_screen/widget/search_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../generated/locales.g.dart';
import '../../../../controller/vendor_home_page_flower_controller.dart';

import '../bottom_navigation_bar_home_screen/widget/flower_item.dart';

class SearchScreen extends GetView<VendorHomePageFlowerController> {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: controller.searchController,
            onChanged: (value) {
              controller.getSearchFlowerList( search: value);
            },
            decoration: InputDecoration(
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.green,
                  ),
                  onPressed: () {
                    controller.clearFilteredFlowerList();
                  },
                ),
                labelText: LocaleKeys.home_search_search.tr,
                prefixIcon:  const SearchAlertDialog()),
          ),
          const SizedBox(height: 16),
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
