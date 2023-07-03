import 'package:get/get.dart';

import '../controller/home_page_flower_controller.dart';


class HomePageFlowerBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => HomePageFlowerController());
  }
  
}