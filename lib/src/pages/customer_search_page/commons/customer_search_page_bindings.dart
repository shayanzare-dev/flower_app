import 'package:get/get.dart';

import '../controller/customer_search_page_controller.dart';


class CustomerSearchPageBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CustomerSearchPageController());
  }
}
