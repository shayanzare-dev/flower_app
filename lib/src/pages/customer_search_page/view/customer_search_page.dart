import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../customer_home_page/view/widget/bottom_navigation_bar_customer_pages/bottom_navigation_bar_customer_home_screen/widget/customer_flower_item.dart';
import '../view/widget/search_alert_dialog.dart';
import '../controller/customer_search_page_controller.dart';

class CustomerSearchPage extends GetView<CustomerSearchPageController> {
  const CustomerSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Cart Flower page'),
          backgroundColor: const Color(0xff04927c)),
      body: Padding(
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
                  labelText: 'Search or for filter press search icon',
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
          ],
        ),
      ),
    );
  }
}
