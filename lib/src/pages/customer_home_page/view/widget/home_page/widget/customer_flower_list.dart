import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/customer_home_page_flower_controller.dart';
import 'customer_flower_item.dart';

class CustomerFlowerList extends GetView<CustomerHomePageFlowerController> {
  const CustomerFlowerList({super.key});

  @override
  Widget build(BuildContext context) => Obx(
        () => ListView.builder(
          shrinkWrap: true,
          itemCount: controller.customerFlowerList.length,
          itemBuilder: (final context, final index) => CustomerFlowerItem(
              flowerItem: controller.customerFlowerList[index]),
        ),
      );
}
