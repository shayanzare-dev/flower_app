import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/locales.g.dart';
import '../../customer_home_page/view/widget/bottom_navigation_bar_customer_pages/bottom_navigation_bar_customer_home_screen/widget/customer_flower_item.dart';
import '../view/widget/search_alert_dialog.dart';
import '../controller/customer_search_page_controller.dart';
import '../view/widget/loading_widget.dart';

class CustomerSearchPage extends GetView<CustomerSearchPageController> {
  const CustomerSearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Search Flower page'),
          backgroundColor: const Color(0xff04927c)),
      body: Column(
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
                    controller.clearSearchFilterFlowersTextField();
                  },
                ),
                labelText: LocaleKeys.home_search_search.tr,
                prefixIcon: const SearchAlertDialog()),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              return _filteredFlowerList();
            }),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Stack(
              children: <Widget>[
                Center(
                  child: LoadingWidget(),
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
  Widget _filteredFlowerList() {
    if (controller.filteredFlowerList.isEmpty) {
      return const Center(
        child: Text('List Is Empty',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xff04927c))),
      );
    }
    return ListView.builder(
      itemCount: controller.filteredFlowerList.length,
      itemBuilder: (final context, final index) => CustomerFlowerItem(
          flowerItem: controller.filteredFlowerList[index]),
    );
  }
}
