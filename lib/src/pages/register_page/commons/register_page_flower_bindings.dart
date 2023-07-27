import 'package:get/get.dart';
import '../controller/register_page_flower_controller.dart';



class RegisterPageFlowerBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => RegisterPageFlowerController());
  }
  
}