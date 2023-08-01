import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/vendor_home_page_flower_controller.dart';
import 'widget/flower_list.dart';


class HomeScreen extends GetView<VendorHomePageFlowerController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RefreshIndicator(
        onRefresh: controller.getFlowerList,
        child: _flowerList(),
      ),
    );
  }

  Widget _flowerList() {
    if (controller.isLoadingFlowerList.value) {
     return const Center(child: CircularProgressIndicator());
    } else if (controller.flowerList.isEmpty) {
      return const Center(
        child: Text('List Is Empty',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xff04927c))),
      );
    }
    return const FlowerList();
  }
}
