import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../customer_home_page/models/bought_flowers_view_model.dart';
import '../../customer_home_page/models/cart_order_view_model.dart';
import '../repositories/vendor_history_page_repository.dart';

class VendorHistoryPageController extends GetxController {
  final SharedPreferences _prefs = Get.find<SharedPreferences>();
  RxList<BoughtFlowersViewModel> boughtFlowerList = RxList();
  RxList<CartOrderViewModel> boughtOrderList = RxList();
  final VendorHistoryPageRepository _repository = VendorHistoryPageRepository();
  String vendorUserEmail = '';

  var isLoading = false.obs;
  void showLoading() {
    isLoading.value = true;
  }
  void hideLoading() {
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {
      getOrderListVendorHistory();
    });
    Future.delayed(const Duration(seconds: 1), () {
      userEmail().then((userEmail) {
        vendorUserEmail = userEmail;
      });
    });
  }

  Future<String> userEmail() async {
    return _prefs.getString('userEmail') ?? 'test@gmail.com';
  }

  Future<void> getOrderListVendorHistory() async {
    showLoading();
    boughtOrderList.clear();
    final result = await _repository.getVendorUserOrdersHistory();
    if (result.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (result.isRight) {
      boughtOrderList.addAll(result.right);
      for (final item in result.right) {
        for (final items in item.boughtFlowers) {
          if (items.flowerListViewModel.vendorUser.email == vendorUserEmail) {
            boughtFlowerList.addAll(item.boughtFlowers);
          }
        }
      }
    }
    hideLoading();
  }
}
