import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/customer_home_page_flower_controller.dart';
import 'bought_item.dart';
import 'cart_flower_item.dart';


class BoughtList extends GetView<CustomerHomePageFlowerController> {
  const BoughtList({super.key});

  @override
  Widget build(BuildContext context) => Obx(() =>  ListView.builder(
    shrinkWrap: true,
    itemCount: controller.boughtFlowerList.length,
    itemBuilder: (final context, final index) =>
        BoughtItem( boughtFlower:controller.boughtFlowerList[index] , ),
  ),
  );
}
