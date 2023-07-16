import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/customer_cart_page_controller.dart';
import 'bought_item.dart';



class BoughtList extends GetView<CustomerCartPageController> {
  const BoughtList({super.key});

  @override
  Widget build(BuildContext context) => Obx(() =>  ListView.builder(
    shrinkWrap: true,
    itemCount: controller.boughtFlowerListCart.length,
    itemBuilder: (final context, final index) =>
        BoughtItem( boughtFlower:controller.boughtFlowerListCart[index] , ),
  ),
  );
}
