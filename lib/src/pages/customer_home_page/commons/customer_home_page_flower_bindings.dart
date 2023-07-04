import 'package:get/get.dart';

import '../controller/customer_home_page_flower_controller.dart';


class CustomerHomePageFlowerBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => CustomerHomePageFlowerController());
  }
  
}