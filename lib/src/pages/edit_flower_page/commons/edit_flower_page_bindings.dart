import 'package:get/get.dart';

import '../controller/edit_flower_page_controller.dart';




class EditFlowerPageBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => EditFlowerPageController());
  }
  
}