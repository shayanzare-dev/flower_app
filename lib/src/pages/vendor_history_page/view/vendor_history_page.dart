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
        child: RefreshIndicator(
          onRefresh: controller.getOrderListVendorHistory,
          child:const VendorBoughtList(),
        ),

      ),
    );
  }
}
