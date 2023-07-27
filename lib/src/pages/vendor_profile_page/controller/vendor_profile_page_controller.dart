import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../flower_app.dart';
import '../../vendor_home_page/models/vendor_view_model.dart';
import '../repositories/vendor_profile_page_repository.dart';

class VendorProfilePageController extends GetxController{
  RxList<VendorViewModel> vendorUser = RxList();
  String vendorUserEmail = '';
  final SharedPreferences _prefs = Get.find<SharedPreferences>();
  final VendorProfilePageRepository _repository =
  VendorProfilePageRepository();



  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {
      getProfileUser();
    });
    Future.delayed(const Duration(seconds: 1), () {
      userEmail().then((userEmail) {
        vendorUserEmail = userEmail;
      });
    });
  }

  Future<void> getProfileUser() async {
    final result = await _repository.getVendorUser(vendorUserEmail);
    if (result.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (result.isRight) {
      vendorUser.addAll(result.right);
    }
  }

  Future<String> userEmail() async {
    return _prefs.getString('userEmail') ?? 'test@gmail.com';
  }

  void goToLoginPage() {
    Get.offAllNamed(RouteNames.loginPageFlower);
  }

}