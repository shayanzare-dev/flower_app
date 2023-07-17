import 'package:get/get.dart';

import '../controller/loading_page_controller.dart';

class LoadingPageBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => LoadingPageController());
  }

}