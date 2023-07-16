import 'package:get/get.dart';

import '../controller/vendor_search_page_controller.dart';


class VendorSearchPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VendorSearchPageController());
  }
}
