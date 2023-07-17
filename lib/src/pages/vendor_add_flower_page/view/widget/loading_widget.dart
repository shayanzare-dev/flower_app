import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/vendor_add_flower_page_controller.dart';



class LoadingWidget extends GetView<VendorAddFlowerPageController> {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.isLoading.value
          ? Container(
              color: Colors.green.withOpacity(0.5),
              child: const Center(
                child: LinearProgressIndicator(),
              ),
            )
          : const SizedBox.shrink();
    });
  }
}
