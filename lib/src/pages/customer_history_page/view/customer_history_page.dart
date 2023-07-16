import 'package:flower_app/src/pages/customer_history_page/view/widget/customer_bought_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/customer_history_page_controller.dart';

class CustomerHistoryPage extends GetView<CustomerHistoryPageController> {
  const CustomerHistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: RefreshIndicator(
          onRefresh: controller.getOrderList,
          child: const CustomerBoughtList(),
        ),
      ),
    );
  }
}
