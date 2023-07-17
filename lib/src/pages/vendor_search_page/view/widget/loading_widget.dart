import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/vendor_search_page_controller.dart';


class LoadingWidget extends GetView<VendorSearchPageController> {
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
