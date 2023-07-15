import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../controller/vendor_home_page_flower_controller.dart';
import 'vendor_bought_item.dart';

class VendorBoughtList extends GetView<VendorHomePageFlowerController> {
  const VendorBoughtList({super.key});

  @override
  Widget build(BuildContext context) => Obx(
        () => ListView.builder(
          shrinkWrap: true,
          itemCount: controller.boughtFlowerList.length,
          itemBuilder: (final context, final index) => VendorBoughtItem(
            boughtFlower: controller.boughtFlowerList[index],
          ),
        ),
      );
}
