import 'package:get/get.dart';

import '../controller/vendor_profile_page_controller.dart';

class VendorProfilePageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VendorProfilePageController());
  }
}
