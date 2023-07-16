import 'package:get/get.dart';

import '../controller/customer_history_page_controller.dart';



class CustomerHistoryPageBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => CustomerHistoryPageController());
  }

}