import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../flower_app.dart';

class LoadingPageController extends GetxController{
  final SharedPreferences _prefs = Get.find<SharedPreferences>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    showLoading();
    isLoggedIn().then((loggedIn) {
      if (loggedIn) {
        showLoading();
        userType().then((userType) {
          if (userType == 1) {
            Get.toNamed(
                RouteNames.loadingPageFlower+ RouteNames.loginPageFlower + RouteNames.vendorHomePageFlower);
            hideLoading();
          } else if (userType == 2) {
            Get.toNamed(
                RouteNames.loadingPageFlower+ RouteNames.loginPageFlower + RouteNames.customerHomePageFlower);
            hideLoading();
          }
        });
      }else{
        Get.toNamed(
            RouteNames.loadingPageFlower+RouteNames.loginPageFlower);
        hideLoading();
      }
    });
  }

  Future<int> userType() async {
    return _prefs.getInt('userType') ?? 1;
  }

  Future<bool> isLoggedIn() async {
    return _prefs.getBool('isLoggedIn') ?? false;
  }


  void showLoading() {
    isLoading.value = true;
  }
  void hideLoading() {
    isLoading.value = false;
  }

}