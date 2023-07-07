import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/vendor_home_page_flower_controller.dart';
import 'flower_item.dart';

class FlowerList extends GetView<VendorHomePageFlowerController> {
  const FlowerList({super.key});

  @override
  Widget build(BuildContext context) => Obx(() =>  ListView.builder(
          shrinkWrap: true,
          itemCount: controller.flowerList.length,
          itemBuilder: (final context, final index) =>
              FlowerItem(flowerItem: controller.flowerList[index]),
        ),
  );
}
