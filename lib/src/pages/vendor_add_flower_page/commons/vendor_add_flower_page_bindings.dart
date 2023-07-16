import 'package:get/get.dart';
import '../controller/vendor_add_flower_page_controller.dart';


class VendorAddFlowerPageBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => VendorAddFlowerPageController());
  }

}