import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:flower_app/flower_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../customer_home_page/models/add_cart_order_dto.dart';
import '../../customer_home_page/models/bought_flowers_view_model.dart';
import '../../customer_home_page/models/cart_order_view_model.dart';
import '../../customer_home_page/models/edit_flower_dto.dart';
import '../../customer_home_page/models/edit_order_dto.dart';
import '../../customer_home_page/models/flower_list_view_model.dart';
import '../../customer_home_page/models/user_view_model.dart';
import '../../vendor_home_page/models/vendor_view_model.dart';
import '../repositories/customer_cart_page_repository.dart';

class CustomerCartPageController extends GetxController {
  final CustomerCartPageRepository _repository = CustomerCartPageRepository();
  RxList<UserViewModel> customerUser = RxList();
  SharedPreferences _prefs = Get.find<SharedPreferences>();
  RxMap<int, int> flowerBuyCount = RxMap();
  RxList<BoughtFlowersViewModel> boughtFlowerListCart = RxList();
  RxList<CartOrderViewModel> cartOrderList = RxList();
  RxInt cartCount = 0.obs;
  String customerUserEmail = '';
  int totalPrice = 0;
  RxBool isLoadingCartListPage = false.obs;
  RxBool isLoadingCartPurchaseBtn = false.obs;
  RxMap<int, RxBool> isLoadingDeleteBtn = RxMap<int, RxBool>();
  RxMap<int, RxBool> isLoadingPlusCart = RxMap<int, RxBool>();
  RxMap<int, RxBool> isLoadingMinusCart = RxMap<int, RxBool>();




  @override
  void onInit() {
    _prefs = Get.find<SharedPreferences>();
    customerUserEmail = _prefs.getString('userEmail') ?? 'test@gmail.com';
    getCustomerUser();
    getOrderCart();
    super.onInit();
  }

  Future<void> getCustomerUser() async {
    final result = await _repository.getCustomerUser(customerUserEmail);
    if (result.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (result.isRight) {
      customerUser.addAll(result.right);
    }
  }



  Future<void> getOrderCart() async {
    isLoadingCartListPage.value = true;
    cartOrderList.clear();
    boughtFlowerListCart.clear();
    cartCount.value = 0;
    final result = await _repository.getCartOrders(customerUserEmail);
    if (result.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (result.isRight) {
      cartOrderList.addAll(result.right);
      for (final item in result.right) {
        boughtFlowerListCart.addAll(item.boughtFlowers);
        for (final items in item.boughtFlowers) {
          isLoadingDeleteBtn[items.flowerListViewModel.id] = false.obs;
          isLoadingPlusCart[items.flowerListViewModel.id] = false.obs;
          isLoadingMinusCart[items.flowerListViewModel.id] = false.obs;
          flowerBuyCount[items.flowerListViewModel.id] = items.buyCount;
          incrementCartCount();
        }
      }
    }
    isLoadingCartListPage.value = false;
  }

  void incrementCartCount() {
    cartCount.value++;
  }

  void decrementCartCount() {
    cartCount.value--;
  }

  RxString formatPrice = ''.obs;
  String priceFormat({required String price}){
    formatPrice.value = '';
    int counter =0;
    for(int i = (price.length-1);i >=0;i--){
      counter++;
      String showPrice = price[i];
      if((counter%3) != 0  && i !=0){
        formatPrice.value = '$showPrice$formatPrice';
      }else if (i == 0){
        formatPrice.value = '$showPrice$formatPrice';
      }else{
        formatPrice.value = ',$showPrice$formatPrice';
      }
    }
    return formatPrice.trim();
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
          isLoadingDeleteBtn[flowerItem.id] = false.obs;
          isLoadingMinusCart[flowerItem.id] = false.obs;
          isLoadingPlusCart[flowerItem.id] = false.obs;
          return Get.snackbar(
            'Register', 'Your update is not successfully code error:$error');
        },
        (String addRecord) async {
      isLoadingDeleteBtn[flowerItem.id] = false.obs;
      isLoadingMinusCart[flowerItem.id] = false.obs;
      isLoadingPlusCart[flowerItem.id] = false.obs;
    });
  }

  void deleteFlowerItemForCartOrder({
    required FlowerListViewModel flowerItem,
    required BoughtFlowersViewModel boughtFlowers,
  }) {
    isLoadingDeleteBtn[flowerItem.id] = true.obs;
    boughtFlowerListCart.refresh();
    final int index = boughtFlowerListCart.indexOf(boughtFlowers);
    int sumBuyPrice = boughtFlowerListCart[index].sumBuyPrice;
    boughtFlowerListCart.removeAt(index);
    decrementCartCount();
    cartOrderList[0].totalPrice = cartOrderList[0].totalPrice - sumBuyPrice;
    totalPrice = totalPrice - sumBuyPrice;
    updateCartOrder(cartId: cartOrderList[0].id, flowerItem: flowerItem);
    refresh();
    cartOrderList.refresh();
  }

  RxBool isButtonEnabled = true.obs;

  void disableButton() {
    isButtonEnabled.value = false;
    Timer(const Duration(seconds: 2), () {
      isButtonEnabled.value = true;
    });
  }

  void editFlowerCountBuyCartPlus(
      {required BoughtFlowersViewModel boughtFlowers}) {
    disableButton();
    isLoadingPlusCart[boughtFlowers.flowerListViewModel.id] = true.obs;
    final int index = boughtFlowerListCart.indexOf(boughtFlowers);
    if (boughtFlowerListCart[index].buyCount <
        boughtFlowerListCart[index].flowerListViewModel.countInStock) {
      boughtFlowerListCart[index].buyCount =
          boughtFlowerListCart[index].buyCount + 1;
      boughtFlowerListCart[index].sumBuyPrice =
          boughtFlowerListCart[index].sumBuyPrice + boughtFlowerListCart[index].flowerListViewModel.price;
      cartOrderList[0].totalPrice =
          cartOrderList[0].totalPrice + boughtFlowerListCart[index].flowerListViewModel.price;
      boughtFlowerListCart.refresh();
      cartOrderList.refresh();
      updateCartOrder(
          cartId: cartOrderList[0].id,
          flowerItem: boughtFlowers.flowerListViewModel);
      refresh();
    } else {
      Get.snackbar('Edit Flower', 'cant plus count buy');
    }
  }

  void editFlowerCountBuyCartMinus(
      {required BoughtFlowersViewModel boughtFlowers}) {
    disableButton();

    final int index = boughtFlowerListCart.indexOf(boughtFlowers);
    isLoadingMinusCart[boughtFlowers.flowerListViewModel.id] = true.obs;
    if (boughtFlowerListCart[index].buyCount > 1) {
      boughtFlowerListCart[index].buyCount =
          boughtFlowerListCart[index].buyCount - 1;
      boughtFlowerListCart[index].sumBuyPrice =
          boughtFlowerListCart[index].sumBuyPrice - boughtFlowerListCart[index].flowerListViewModel.price;
      cartOrderList[0].totalPrice =
          cartOrderList[0].totalPrice - boughtFlowerListCart[index].flowerListViewModel.price;
      boughtFlowerListCart.refresh();
      cartOrderList.refresh();
      updateCartOrder(
          cartId: cartOrderList[0].id,
          flowerItem: boughtFlowers.flowerListViewModel);
      refresh();
    } else {

      deleteFlowerItemForCartOrder(
          flowerItem: boughtFlowers.flowerListViewModel,
          boughtFlowers: boughtFlowers);
      Get.snackbar('Cart', 'your item is deleted');
    }
  }

  void deleteAlertDialogSelect({
    required BoughtFlowersViewModel boughtFlowers,
    required int itemSelect,
    required FlowerListViewModel flowerItem,
    required BuildContext context,
  }) {
    switch (itemSelect) {
      case 1:
        break;
      case 2:
        deleteFlowerItemForCartOrder(
            flowerItem: flowerItem, boughtFlowers: boughtFlowers);
        Navigator.of(context).pop();
        break;
    }
  }

  Future<void> onSubmitPurchaseCartOrder() async {

    isLoadingCartPurchaseBtn.value =true;
    if (boughtFlowerListCart.isEmpty) {
      Get.snackbar('Add cart', 'Your cart  is empty');
    } else {
      final AddCartOrderDto dto = AddCartOrderDto(
          user: customerUser.first,
          dateTime: cartOrderList[0].dateTime,
          totalPrice: cartOrderList[0].totalPrice,
          boughtFlowers: boughtFlowerListCart);
      final Either<String, String> resultOrException =
          (await _repository.addCartOrderToOrderList(dto));
      resultOrException.fold(
          (String error) => Get.snackbar('Register',
              'Your registration is not successfully code error:$error'),
          (String addRecord) {
        Get.snackbar('Add cart', 'Your Add order is successfully');
        deleteCartOrder(cartId: cartOrderList[0].id);
        cartCount.value = 0;
      });
    }
  }

  Future<void> editCountFlowerBuy(
      {required FlowerListViewModel flowerItem, required int countBuy}) async {
    final EditFlowerDto dto = EditFlowerDto(
        id: flowerItem.id,
        price: flowerItem.price,
        shortDescription: flowerItem.shortDescription,
        countInStock: flowerItem.countInStock - countBuy,
        category: flowerItem.category,
        name: flowerItem.name,
        color: flowerItem.color,
        image: flowerItem.image,
        vendorUser: VendorViewModel(
            id: flowerItem.vendorUser.id,
            passWord: flowerItem.vendorUser.passWord,
            firstName: flowerItem.vendorUser.firstName,
            lastName: flowerItem.vendorUser.lastName,
            email: flowerItem.vendorUser.email,
            image: flowerItem.vendorUser.image,
            userType: flowerItem.vendorUser.userType));
    final Either<String, String> resultOrException =
        (await _repository.editFlower(dto, flowerItem.id));
    resultOrException.fold(
        (String error) => Get.snackbar(
            'Edit', 'Your edit is not successfully code error:$error'),
        (String editFlower) {
        });
    return;
  }

  void minusCountInStockFlower() async {
    for (final item in boughtFlowerListCart) {
      await editCountFlowerBuy(
          flowerItem: item.flowerListViewModel, countBuy: item.buyCount);
    }
    isLoadingCartPurchaseBtn.value=false;
    refresh();
  }

  Future<void> deleteCartOrder({required int cartId}) async {
    final result = await _repository.deleteCartOrder(cartId);
    result.fold((left) => Get.snackbar('error', result.left),
        (right) {
          minusCountInStockFlower();
          Get.offAllNamed(RouteNames.customerHomePageFlower);
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
}
