import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../customer_home_page/models/bought_flowers_view_model.dart';
import '../../customer_home_page/models/cart_order_view_model.dart';
import '../repositories/customer_history_page_repository.dart';

class CustomerHistoryPageController extends GetxController {
  final CustomerHistoryPageRepository _repository =
      CustomerHistoryPageRepository();
  SharedPreferences _prefs = Get.find<SharedPreferences>();
  String customerUserEmail = '';
  RxList<BoughtFlowersViewModel> boughtFlowerList = RxList();
  RxList<CartOrderViewModel> boughtOrderList = RxList();

  RxBool isLoadingHistoryPage = false.obs;

  void showLoading() {
    isLoadingHistoryPage.value = true;
  }

  void hideLoading() {
    isLoadingHistoryPage.value = false;
  }

  @override
  void onInit() {
    _prefs = Get.find<SharedPreferences>();
    customerUserEmail = _prefs.getString('userEmail') ?? 'test@gmail.com';
    getOrderList();
    super.onInit();
  }

  Future<void> getOrderList() async {
    showLoading();
    boughtOrderList.clear();
    boughtFlowerList.clear();
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
