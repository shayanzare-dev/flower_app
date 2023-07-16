import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/customer_history_page_controller.dart';
import 'customer_bought_item.dart';

class CustomerBoughtList extends GetView<CustomerHistoryPageController> {
  const CustomerBoughtList({super.key});

  @override
  Widget build(BuildContext context) => Obx(
        () => ListView.builder(
          shrinkWrap: true,
          itemCount: controller.boughtFlowerList.length,
          itemBuilder: (final context, final index) => CustomerBoughtItem(
            boughtFlower: controller.boughtFlowerList[index],
          ),
        ),
      );
}
