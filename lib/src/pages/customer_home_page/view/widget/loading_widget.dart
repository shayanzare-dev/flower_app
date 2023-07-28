import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/customer_home_page_flower_controller.dart';

class LoadingWidget extends GetView<CustomerHomePageFlowerController> {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.isLoadingCustomerFlowerList.value
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
