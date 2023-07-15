import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/customer_home_page_flower_controller.dart';
import 'widget/customer_bought_list.dart';


class CustomerHistoryScreen extends GetView<CustomerHomePageFlowerController> {
  CustomerHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: RefreshIndicator(
        onRefresh: controller.getFlowerList,
        child:const CustomerBoughtList(),
      ),

    );
  }


}
