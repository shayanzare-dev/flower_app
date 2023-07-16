import 'package:get/get.dart';

import '../controller/customer_profile_page_controller.dart';

class CustomerProfilePageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CustomerProfilePageController());
  }
}
