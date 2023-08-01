import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/locales.g.dart';
import '../../vendor_home_page/view/widget/home_page/widget/flower_item.dart';
import '../view/widget/search_alert_dialog.dart';
import '../controller/vendor_search_page_controller.dart';
import '../view/widget/loading_widget.dart';

class VendorSearchPage extends GetView<VendorSearchPageController> {
  const VendorSearchPage({Key? key}) : super(key: key);

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
              controller.getSearchFlowerList( search: value);
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
      itemBuilder: (final context, final index) => FlowerItem(
          flowerItem: controller.filteredFlowerList[index]),
    );
  }
}
