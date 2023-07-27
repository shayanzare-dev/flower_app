import 'dart:async';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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

class CustomerCartPageController extends GetxController{
  final CustomerCartPageRepository _repository = CustomerCartPageRepository();
  RxList<UserViewModel> customerUser = RxList();
  SharedPreferences _prefs = Get.find<SharedPreferences>();
  RxMap<int, int> flowerBuyCount = RxMap();
  RxList<BoughtFlowersViewModel> boughtFlowerListCart = RxList();
  RxList<CartOrderViewModel> cartOrderList = RxList();
  RxInt cartCount = 0.obs;
  String customerUserEmail = '';
  int totalPrice = 0;
  var isLoading = false.obs;
  RxBool isLoadingPlusCart = false.obs;
  RxBool isLoadingMinusCart = false.obs;

  void showLoading() {
    isLoading.value = true;
  }

  void hideLoading() {
    isLoading.value = false;
  }


  @override
  void onInit() {
    _prefs = Get.find<SharedPreferences>();
    Future.delayed(const Duration(seconds: 1), () {
      customerUserEmail = _prefs.getString('userEmail') ?? 'test@gmail.com';
      getCustomerUser();
    });
    Future.delayed(const Duration(seconds: 2), () {
      getOrderCart();
    });
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
          flowerBuyCount[items.flowerListViewModel.id] = items.buyCount;
          incrementCartCount();
        }
      }
    }
  }
  void incrementCartCount() {
    cartCount.value++;
  }

  void decrementCartCount() {
    cartCount.value--;
  }

  void addFlowerToBoughtFlowers({required FlowerListViewModel flowerItem}) {
    int? buyCount = flowerBuyCount[flowerItem.id];
    if (buyCount == 0) {
      Get.snackbar('Add Flower', 'can not add to cart');
    } else {
      showLoading();
      DateTime dateTimeNow = DateTime.now();
      DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      String dateTime = dateFormat.format(dateTimeNow);
      String inputStringPrice = flowerItem.price;
      int intFlowerItemPrice = int.parse(inputStringPrice.replaceAll(',', ''));
      int sumBuyPrice = buyCount! * intFlowerItemPrice;
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
        Get.snackbar('Add Flower', 'add to cart');
        addCartOrder();
        boughtFlowerListCart.clear();
        cartOrderList.clear();
        refresh();
        hideLoading();
      } else {
        cartOrderList.clear();
        cartOrderList.add(cartOrder);
        Get.snackbar('Add Flower', 'add to cart');
        updateCartOrder(cartId: cartOrderList[0].id);
        refresh();
        incrementCartCount();
        hideLoading();
      }
    }
  }

  Future<void> addCartOrder() async {
    showLoading();
    final AddCartOrderDto dto = AddCartOrderDto(
        user: customerUser.first,
        dateTime: cartOrderList[0].dateTime,
        totalPrice: cartOrderList[0].totalPrice,
        boughtFlowers: boughtFlowerListCart);

    final Either<String, String> resultOrException =
    (await _repository.addCartOrder(dto));
    resultOrException.fold(
            (String error) => Get.snackbar('Register',
            'Your registration is not successfully code error:$error'),
            (String addRecord) async {
          Get.snackbar('Add cart', 'Your Add order is successfully');
        });
  }

  Future<void> updateCartOrder({required int cartId}) async {
    final EditCartOrderDto dto = EditCartOrderDto(
        user: customerUser.first,
        dateTime: cartOrderList[0].dateTime,
        totalPrice: cartOrderList[0].totalPrice,
        boughtFlowers: boughtFlowerListCart,
        id: cartOrderList[0].id);

    final Either<String, String> resultOrException =
    (await _repository.updateCartOrder(dto, cartId));
    resultOrException.fold(
            (String error) => Get.snackbar(
            'Register', 'Your update is not successfully code error:$error'),
            (String addRecord) async {
          Get.snackbar('Update cart', 'Your Update Cart is successfully');
        });
    hideLoading();
  }

  void deleteFlowerItemForCartOrder({
    required FlowerListViewModel flowerItem,
    required BoughtFlowersViewModel boughtFlowers,
  }) {
    final int index = boughtFlowerListCart.indexOf(boughtFlowers);
    int sumBuyPrice = boughtFlowerListCart[index].sumBuyPrice;
    boughtFlowerListCart.removeAt(index);
    decrementCartCount();
    cartOrderList[0].totalPrice = cartOrderList[0].totalPrice - sumBuyPrice;
    totalPrice = totalPrice - sumBuyPrice;
    updateCartOrder(cartId: cartOrderList[0].id);
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
    isLoadingPlusCart.value = true;
    final int index = boughtFlowerListCart.indexOf(boughtFlowers);
    if (boughtFlowerListCart[index].buyCount <
        boughtFlowerListCart[index].flowerListViewModel.countInStock) {
      boughtFlowerListCart[index].buyCount =
          boughtFlowerListCart[index].buyCount + 1;
      String inputStringPrice =
          boughtFlowerListCart[index].flowerListViewModel.price;
      int intFlowerItemPrice = int.parse(inputStringPrice.replaceAll(',', ''));
      boughtFlowerListCart[index].sumBuyPrice =
          boughtFlowerListCart[index].sumBuyPrice + intFlowerItemPrice;
      cartOrderList[0].totalPrice =
          cartOrderList[0].totalPrice + intFlowerItemPrice;
      boughtFlowerListCart.refresh();
      cartOrderList.refresh();
      updateCartOrder(cartId: cartOrderList[0].id);
      isLoadingPlusCart.value = false;
      refresh();
    } else {
      Get.snackbar('Edit Flower', 'cant plus count buy');
    }
  }

  void editFlowerCountBuyCartMinus(
      {required BoughtFlowersViewModel boughtFlowers}) {
    disableButton();
    isLoadingMinusCart.value = true;
    final int index = boughtFlowerListCart.indexOf(boughtFlowers);
    if (boughtFlowerListCart[index].buyCount > 1) {
      boughtFlowerListCart[index].buyCount =
          boughtFlowerListCart[index].buyCount - 1;
      String inputStringPrice =
          boughtFlowerListCart[index].flowerListViewModel.price;
      int intFlowerItemPrice = int.parse(inputStringPrice.replaceAll(',', ''));
      boughtFlowerListCart[index].sumBuyPrice =
          boughtFlowerListCart[index].sumBuyPrice -
              intFlowerItemPrice;
      cartOrderList[0].totalPrice = cartOrderList[0].totalPrice -
          intFlowerItemPrice;
      boughtFlowerListCart.refresh();
      cartOrderList.refresh();
      updateCartOrder(cartId: cartOrderList[0].id);
      isLoadingMinusCart.value = false;
      refresh();
    } else {
      isLoadingMinusCart.value = false;
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
            (String editFlower) {});
    return;
  }

  Future<void> onSubmitPurchaseCartOrder() async {
    disableButton();
    showLoading();
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
      Future.delayed(const Duration(seconds: 2), () {
        minusCountInStockFlower();
        hideLoading();
      });
    }
  }

  void minusCountInStockFlower() async {
    for (final item in boughtFlowerListCart) {
      await editCountFlowerBuy(
          flowerItem: item.flowerListViewModel, countBuy: item.buyCount);
    }
    refresh();
  }

  Future<void> deleteCartOrder({required int cartId}) async {
    final result = await _repository.deleteCartOrder(cartId);
    if (result.right == 'success') {
      Get.snackbar('done', result.right);
    } else {
      Get.snackbar('error', result.left);
    }
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


}