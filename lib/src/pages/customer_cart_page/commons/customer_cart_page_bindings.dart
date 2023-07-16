import 'package:get/get.dart';
import '../controller/customer_cart_page_controller.dart';


class CustomerCartPageBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => CustomerCartPageController());
  }

}