import 'package:get/get.dart';

import '../controller/login_page_flower_controller.dart';

class LoginPageFlowerBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => LoginPageFlowerController());
  }
  
}