import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/register_page_flower_controller.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Get.find<RegisterPageFlowerController>().isLoading.value
          ? Container(
              color: Colors.green.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : const SizedBox.shrink();
    });
  }
}
