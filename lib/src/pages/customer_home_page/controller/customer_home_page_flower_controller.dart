import 'dart:async';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../flower_app.dart';
import '../models/add_cart_order_dto.dart';
import '../models/bought_flowers_view_model.dart';
import '../models/cart_order_view_model.dart';
import '../models/edit_order_dto.dart';
import '../models/flower_list_view_model.dart';
import '../models/user_view_model.dart';
import '../repositories/customer_home_page_flower_repository.dart';

class CustomerHomePageFlowerController extends GetxController {
  final CustomerHomePageFlowerRepository _repository =
      CustomerHomePageFlowerRepository();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  SharedPreferences _prefs = Get.find<SharedPreferences>();
  RxList<UserViewModel> customerUser = RxList();
  RxList<FlowerListViewModel> customerFlowerList = RxList();
  RxMap<int, int> flowerBuyCount = RxMap();
  RxList<BoughtFlowersViewModel> boughtFlowerListCart = RxList();
  RxList<CartOrderViewModel> cartOrderList = RxList();
  RxInt cartCount = 0.obs;
  String customerUserEmail = '';
  int totalPrice = 0;
  RxBool isLoadingCustomerFlowerList = false.obs;
  RxMap<int, RxBool> isLoadingAddToCartBtn = RxMap<int, RxBool>();
  RxBool isButtonEnabled = true.obs;
  RxBool isLoadingPlusCart = false.obs;
  RxBool isLoadingMinusCart = false.obs;

  void showLoading() {
    isLoadingCustomerFlowerList.value = true;
  }

  void hideLoading() {
    isLoadingCustomerFlowerList.value = false;
  }

  @override
  void onInit() {
    _prefs = Get.find<SharedPreferences>();
    customerUserEmail = _prefs.getString('userEmail') ?? 'test@gmail.com';
    getCustomerUser();
    getFlowerList();
    super.onInit();
  }

  @override
  Future<void> refresh() async {
    customerUserEmail = _prefs.getString('userEmail') ?? 'test@gmail.com';
    getCustomerUser();
    getFlowerList();
  }

  RxString formatPrice = ''.obs;

  String priceFormat({required String price}) {
    formatPrice.value = '';
    int counter = 0;
    for (int i = (price.length - 1); i >= 0; i--) {
      counter++;
      String showPrice = price[i];
      if ((counter % 3) != 0 && i != 0) {
        formatPrice.value = '$showPrice$formatPrice';
      } else if (i == 0) {
        formatPrice.value = '$showPrice$formatPrice';
      } else {
        formatPrice.value = ',$showPrice$formatPrice';
      }
    }
    return formatPrice.trim();
  }

  Future<void> getOrderCart() async {
    cartOrderList.clear();
    boughtFlowerListCart.clear();
    cartCount.value = 0;
    final result = await _repository.getCartOrders(customerUserEmail);
    if (result.isLeft) {
      Get.snackbar('get order cart', 'cart not found');
    } else if (result.isRight) {
      cartOrderList.addAll(result.right);
      for (final item in result.right) {
        boughtFlowerListCart.addAll(item.boughtFlowers);
        for (final items in item.boughtFlowers) {
          flowerBuyCount[items.flowerListViewModel.id] = items.buyCount;
          incrementCartCount();
        }
      }
    }
    isButtonEnabled.value = true;
    isLoadingCustomerFlowerList.value = false;
  }

  Future<void> getFlowerList() async {
    isLoadingCustomerFlowerList.value = true;
    isButtonEnabled.value = false;
    customerFlowerList.clear();
    final result = await _repository.getFlowerList();
    if (result.isLeft) {
      Get.snackbar('Flower List', 'Flowers not found');
    } else if (result.isRight) {
      customerFlowerList.addAll(result.right);
      for (final item in result.right) {
        flowerBuyCount[item.id] = 0;
        isLoadingAddToCartBtn[item.id] = false.obs;
      }
      getOrderCart();
    }
  }

  Future<void> getCustomerUser() async {
    final result = await _repository.getCustomerUser(customerUserEmail);
    if (result.isLeft) {
      Get.snackbar('get user', 'user not found');
    } else if (result.isRight) {
      customerUser.addAll(result.right);
    }
  }

  void incrementCartCount() {
    cartCount.value++;
  }

  void decrementCartCount() {
    cartCount.value--;
  }

  void addFlowerToBoughtFlowers({required FlowerListViewModel flowerItem}) {
    isLoadingAddToCartBtn[flowerItem.id]!.value = true;
    customerFlowerList.refresh();
    int? buyCount = flowerBuyCount[flowerItem.id];
    if (buyCount == 0) {
      Get.snackbar('Add Flower', 'can not add to cart');
      isLoadingAddToCartBtn[flowerItem.id]!.value = false;
    } else {
      DateTime dateTimeNow = DateTime.now();
      DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      String dateTime = dateFormat.format(dateTimeNow);
      int sumBuyPrice = buyCount! * flowerItem.price;
      BoughtFlowersViewModel boughtFlowers = BoughtFlowersViewModel(
          flowerListViewModel: flowerItem,
          buyCount: buyCount,
          sumBuyPrice: sumBuyPrice,
          dateTime: dateTime,
          user: customerUser[0]);
      boughtFlowerListCart
          .removeWhere((item) => item.flowerListViewModel.id == flowerItem.id);
      boughtFlowerListCart.add(boughtFlowers);
      totalPrice = 0;
      for (final item in boughtFlowerListCart) {
        totalPrice = totalPrice + item.sumBuyPrice;
      }
      CartOrderViewModel cartOrder = CartOrderViewModel(
        user: customerUser.first,
        dateTime: dateTime,
        totalPrice: totalPrice,
        boughtFlowers: boughtFlowerListCart,
        id: cartOrderList.isEmpty ? 1 : cartOrderList[0].id,
      );
      if (cartOrderList.isEmpty) {
        cartOrderList.add(cartOrder);
        addCartOrder(flowerItem: flowerItem);
        boughtFlowerListCart.clear();
        cartOrderList.clear();
      } else {
        cartOrderList.clear();
        cartOrderList.add(cartOrder);
        updateCartOrder(cartId: cartOrderList[0].id, flowerItem: flowerItem);
        incrementCartCount();
      }
    }
  }

  Future<void> addCartOrder({required FlowerListViewModel flowerItem}) async {
    final AddCartOrderDto dto = AddCartOrderDto(
        user: customerUser.first,
        dateTime: cartOrderList[0].dateTime,
        totalPrice: cartOrderList[0].totalPrice,
        boughtFlowers: boughtFlowerListCart);
    final Either<String, String> resultOrException =
        (await _repository.addCartOrder(dto));
    resultOrException.fold(
        (String error) {
          isLoadingAddToCartBtn[flowerItem.id]!.value = false;
          return Get.snackbar('add order cart',
            'Your order cart is not successfully code error:$error');
        },
        (String addRecord) async {
      isLoadingAddToCartBtn[flowerItem.id]!.value = false;
      getFlowerList();
    });
  }

  Future<void> updateCartOrder(
      {required int cartId, required FlowerListViewModel flowerItem}) async {
    final EditCartOrderDto dto = EditCartOrderDto(
        user: customerUser.first,
        dateTime: cartOrderList[0].dateTime,
        totalPrice: cartOrderList[0].totalPrice,
        boughtFlowers: boughtFlowerListCart,
        id: cartOrderList[0].id);
    final Either<String, String> resultOrException =
        (await _repository.updateCartOrder(dto, cartId));
    resultOrException.fold(
        (String error) {
          isLoadingAddToCartBtn[flowerItem.id]!.value = false;
          return Get.snackbar('update order cart',
              'Your order cart is not successfully code error:$error');
        },
        (String addRecord) async {
      isLoadingAddToCartBtn[flowerItem.id]!.value = false;
      getFlowerList();
    });
  }

  void editBuyCountFlowerPlus({required FlowerListViewModel flowerItem}) {
    if (flowerItem.countInStock > flowerBuyCount[flowerItem.id]!) {
      flowerBuyCount[flowerItem.id] = (flowerBuyCount[flowerItem.id]! + 1);
    } else {
      Get.snackbar('edit Flower', 'can not plus count in stock');
    }
    return;
  }


  void editBuyCountFlowerMinus({required FlowerListViewModel flowerItem}) {
    if (flowerBuyCount[flowerItem.id]! > 0) {
      flowerBuyCount[flowerItem.id] = (flowerBuyCount[flowerItem.id]! - 1);
    } else {
      Get.snackbar('edit Flower', 'can not minus count in stock');
    }
    return;
  }

  void clearLoginStatus() async {
    await _prefs.clear();
  }

  void goToLoginPage() {
    Get.offAllNamed(RouteNames.loadingPageFlower + RouteNames.loginPageFlower);
  }
}
