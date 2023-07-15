import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controller/customer_home_page_flower_controller.dart';
import '../../bottom_navigation_bar_customer_cart_screen/widget/bought_item.dart';
import '../../bottom_navigation_bar_customer_cart_screen/widget/cart_flower_item.dart';
import 'customer_bought_item.dart';


class CustomerBoughtList extends GetView<CustomerHomePageFlowerController> {
  const CustomerBoughtList({super.key});

  @override
  Widget build(BuildContext context) => Obx(() =>  ListView.builder(
    shrinkWrap: true,
    itemCount: controller.boughtFlowerList.length,
    itemBuilder: (final context, final index) =>
        CustomerBoughtItem( boughtFlower:controller.boughtFlowerList[index] , ),
  ),
  );
}
