import 'package:flower_app/src/pages/customer_home_page/view/widget/bottom_navigation_bar_customer_pages/bottom_navigation_bar_customer_search_screen/widget/search_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../generated/locales.g.dart';
import '../../loading_widget.dart';
import '../../../../controller/customer_home_page_flower_controller.dart';
import '../bottom_navigation_bar_customer_home_screen/widget/customer_flower_item.dart';

class CustomerSearchScreen extends GetView<CustomerHomePageFlowerController> {
  const CustomerSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: controller.searchController,
            onChanged: (value) {
              controller.getSearchFlowerList(search: value);
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
                prefixIcon: const SearchAlertDialog()),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.filteredFlowerList.length,
                itemBuilder: (final context, final index) => CustomerFlowerItem(
                    flowerItem: controller.filteredFlowerList[index]),
              );
            }),
          ),
          const Stack(
            children: <Widget>[
              Center(
                child: LoadingWidget(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
