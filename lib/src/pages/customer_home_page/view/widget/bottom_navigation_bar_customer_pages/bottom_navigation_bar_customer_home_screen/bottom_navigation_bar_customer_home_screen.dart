import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/customer_home_page_flower_controller.dart';
import 'widget/customer_flower_list.dart';


class CustomerHomeScreen extends GetView<CustomerHomePageFlowerController> {
  CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: RefreshIndicator(
        onRefresh: controller.getFlowerList,
        child:const CustomerFlowerList(),
      ),

    );
  }


}
