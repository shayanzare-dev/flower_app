import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/vendor_home_page_flower_controller.dart';
import 'widget/flower_list.dart';

class HomeScreen extends GetView<VendorHomePageFlowerController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: RefreshIndicator(
        onRefresh: controller.getFlowerList,
        child: const FlowerList(),
      ),
    );
  }
}
