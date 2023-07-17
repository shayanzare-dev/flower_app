import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../customer_home_page/models/bought_flowers_view_model.dart';
import '../../customer_home_page/models/cart_order_view_model.dart';
import '../repositories/customer_history_page_repository.dart';

class CustomerHistoryPageController extends GetxController {
  final CustomerHistoryPageRepository _repository =
      CustomerHistoryPageRepository();
  final SharedPreferences _prefs = Get.find<SharedPreferences>();
  String customerUserEmail = '';
  RxList<BoughtFlowersViewModel> boughtFlowerList = RxList();
  RxList<CartOrderViewModel> boughtOrderList = RxList();

  var isLoading = false.obs;

  void showLoading() {
    isLoading.value = true;
  }

  void hideLoading() {
    isLoading.value = false;
  }

  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 2), () {
      getOrderList();
    });
    Future.delayed(const Duration(seconds: 1), () {
      userEmail().then((userEmail) {
        customerUserEmail = userEmail;
      });
    });
    super.onInit();
  }

  Future<String> userEmail() async {
    return _prefs.getString('userEmail') ?? 'test@gmail.com';
  }

  Future<void> getOrderList() async {
    showLoading();
    boughtOrderList.clear();
    final result = await _repository.getCustomerUserOrders(customerUserEmail);
    if (result.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (result.isRight) {
      boughtOrderList.addAll(result.right);
      for (final item in result.right) {
        boughtFlowerList.addAll(item.boughtFlowers);
      }
    }
    hideLoading();
  }
}
