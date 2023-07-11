import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../flower_app.dart';
import '../models/flower_list_view_model.dart';
import '../models/user_view_model.dart';
import '../repositories/customer_home_page_flower_repository.dart';
import '../view/widget/bottom_navigation_bar_customer_cart_screen.dart';
import '../view/widget/bottom_navigation_bar_customer_history_screen.dart';
import '../view/widget/bottom_navigation_bar_customer_home_screen.dart';
import '../view/widget/bottom_navigation_bar_customer_profile_screen.dart';
import '../view/widget/bottom_navigation_bar_customer_search_screen.dart';

class CustomerHomePageFlowerController extends GetxController{
  final CustomerHomePageFlowerRepository _repository =
  CustomerHomePageFlowerRepository();
  RxList<UserViewModel> customerUser = RxList();

  RxList<FlowerListViewModel> customerFlowerList = RxList();

  RxMap<int, int> flowerBuyCount = RxMap();

  final selectedIndex = RxInt(0);

  static List<Widget> widgetOptions = <Widget>[
    CustomerHomeScreen(),
    CustomerCartScreen(),
    CustomerSearchScreen(),
    CustomerHistoryScreen(),
    CustomerProfileScreen(),
  ];

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  String customerUserEmail = '';

  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 2), () {
      getCustomerUser();
      getFlowerList();
    });
    Future.delayed(const Duration(seconds: 1), () {
      userEmail().then((userEmail) {
        customerUserEmail = userEmail;
      });
    });
    super.onInit();
  }

  void editBuyCountFlowerPlus(FlowerListViewModel flowerItem)  {
    if (flowerItem.countInStock > flowerBuyCount[flowerItem.id]!) {
      flowerBuyCount[flowerItem.id] = (flowerBuyCount[flowerItem.id]! + 1);
    } else {
      Get.snackbar('edit Flower', 'can not plus count in stock');
    }
    return;
  }

  void editBuyCountFlowerMinus(FlowerListViewModel flowerItem)  {
    if (flowerBuyCount[flowerItem.id]! > 0) {
      flowerBuyCount[flowerItem.id] = (flowerBuyCount[flowerItem.id]! - 1);
    } else {
      Get.snackbar('edit Flower', 'can not minus count in stock');
    }
    return;
  }


  Future<String> userEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail') ?? 'test@gmail.com';
  }

  Future<void> getFlowerList() async {
    customerFlowerList.clear();
    final result = await _repository.getFlowerList();
    if (result.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (result.isRight) {
      customerFlowerList.addAll(result.right);
      for (final item in result.right) {
        flowerBuyCount[item.id] = 0;
      }
    }
  }

  Future<void> getCustomerUser() async {
    final result = await _repository.getCustomerUser(customerUserEmail);
    if (result.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (result.isRight) {
      customerUser.addAll(result.right);
    }
  }

  void goToLoginPage() {
    Get.offAndToNamed(RouteNames.loginPageFlower);
  }
}