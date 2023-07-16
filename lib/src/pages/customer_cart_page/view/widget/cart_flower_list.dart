import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/customer_cart_page_controller.dart';
import 'cart_flower_item.dart';


class CartFlowerList extends GetView<CustomerCartPageController> {
  const CartFlowerList({super.key});

  @override
  Widget build(BuildContext context) => Obx(() =>  ListView.builder(
    shrinkWrap: true,
    itemCount: controller.cartOrderList.length,
    itemBuilder: (final context, final index) =>
        CartFlowerItem( cartOrderItem: controller.cartOrderList[index] ,),
  ),
  );
}
