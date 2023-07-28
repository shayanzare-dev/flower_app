import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/vendor_history_page_controller.dart';
import 'widget/vendor_bought_list.dart';

class VendorHistoryPage extends GetView<VendorHistoryPageController> {
  const VendorHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('History Flower page'),
          backgroundColor: const Color(0xff04927c)),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Obx(() =>  RefreshIndicator(
            onRefresh: controller.getOrderListVendorHistory,
            child: _boughtFlowerList(),
          ),
        ),
      ),
    );


  }
  Widget _boughtFlowerList() {
    if (controller.isLoadingHistoryPage.value) {
      return const Center(child: CircularProgressIndicator());
    } else
    if (controller.boughtFlowerList.isEmpty) {
      return const Center(
        child: Text('List Is Empty',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xff04927c))),
      );
    }
    return const VendorBoughtList();
  }

}
