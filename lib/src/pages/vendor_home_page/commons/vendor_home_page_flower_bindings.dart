import 'package:get/get.dart';

import '../controller/vendor_home_page_flower_controller.dart';


class VendorHomePageFlowerBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => VendorHomePageFlowerController());
  }
  
}