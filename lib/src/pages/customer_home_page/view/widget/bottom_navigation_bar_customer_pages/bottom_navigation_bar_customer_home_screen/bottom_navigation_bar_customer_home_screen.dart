import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/customer_home_page_flower_controller.dart';
import 'widget/customer_flower_list.dart';

class CustomerHomeScreen extends GetView<CustomerHomePageFlowerController> {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RefreshIndicator(
        onRefresh: controller.refresh,
        child: _customerFlowerList(),
      ),
    );
  }

  Widget _customerFlowerList() {
    if (controller.isLoadingCustomerFlowerList.value) {
      return const Center(child: CircularProgressIndicator());
    } else
    if (controller.customerFlowerList.isEmpty) {
      return const Center(
        child: Text('List Is Empty',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xff04927c))),
      );
    }
    return const CustomerFlowerList();
  }
}
