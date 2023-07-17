import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../vendor_home_page/view/widget/bottom_navigation_bar_pages/bottom_navigation_bar_home_screen/widget/flower_item.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                  labelText: 'Search or for filter press search icon',
                  prefixIcon: const SearchAlertDialog()),
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
            const Stack(
              children: <Widget>[
                Center(
                  child: LoadingWidget(),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }
}
