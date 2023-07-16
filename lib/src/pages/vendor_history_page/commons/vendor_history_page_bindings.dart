import 'package:get/get.dart';

import '../controller/vendor_history_page_controller.dart';



class VendorHistoryPageBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => VendorHistoryPageController());
  }

}