import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../flower_app.dart';
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
  final SharedPreferences _prefs = Get.find<SharedPreferences>();
  RxMap<int, int> flowerBuyCount = RxMap();
  RxList<BoughtFlowersViewModel> boughtFlowerListCart = RxList();
  RxList<CartOrderViewModel> cartOrderList = RxList();
  RxInt cartCount = 0.obs;
  String customerUserEmail = '';
  int totalPrice = 0;

  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 2), () {
      getCustomerUser();
      getOrderCart();
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
    final result = await _repository.getCartOrders(customerUserEmail);
    if (result.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (result.isRight) {
      cartOrderList.addAll(result.right);
      for (final item in result.right) {
        boughtFlowerListCart.addAll(item.boughtFlowers);
        for (final items in item.boughtFlowers) {
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
      // editCountFlowerBuy(flowerItem, buyCount);
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
        flowerBuyCount[flowerItem.id] = 0;
        addCartOrder();
        boughtFlowerListCart.clear();
        cartOrderList.clear();
        refresh();
      } else {
        cartOrderList.clear();
        cartOrderList.add(cartOrder);
        Get.snackbar('Add Flower', 'add to cart');
        flowerBuyCount[flowerItem.id] = 0;
        updateCartOrder( cartId: cartOrderList[0].id);
        incrementCartCount();
      }
    }
  }
  Future<void> addCartOrder() async {
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
          Get.snackbar('Add cart', 'Your Add order is successfully');
        });
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
    updateCartOrder( cartId: cartOrderList[0].id);
    cartOrderList.refresh();
  }
  void editFlowerCountBuyCartPlus({required BoughtFlowersViewModel boughtFlowers}) {
    final int index = boughtFlowerListCart.indexOf(boughtFlowers);
    if (boughtFlowerListCart[index].buyCount <
        boughtFlowerListCart[index].flowerListViewModel.countInStock) {
      boughtFlowerListCart[index].buyCount =
          boughtFlowerListCart[index].buyCount + 1;
      boughtFlowerListCart[index].sumBuyPrice =
          boughtFlowerListCart[index].sumBuyPrice +
              boughtFlowerListCart[index].flowerListViewModel.price;
      cartOrderList[0].totalPrice = cartOrderList[0].totalPrice +
          boughtFlowerListCart[index].flowerListViewModel.price;
      boughtFlowerListCart.refresh();
      cartOrderList.refresh();
      updateCartOrder( cartId: cartOrderList[0].id);
    } else {
      Get.snackbar('Edit Flower', 'cant plus count buy');
    }
  }
  void editFlowerCountBuyCartMinus({required BoughtFlowersViewModel boughtFlowers}) {
    final int index = boughtFlowerListCart.indexOf(boughtFlowers);
    if (boughtFlowerListCart[index].buyCount > 1) {
      boughtFlowerListCart[index].buyCount =
          boughtFlowerListCart[index].buyCount - 1;
      boughtFlowerListCart[index].sumBuyPrice =
          boughtFlowerListCart[index].sumBuyPrice -
              boughtFlowerListCart[index].flowerListViewModel.price;
      cartOrderList[0].totalPrice = cartOrderList[0].totalPrice -
          boughtFlowerListCart[index].flowerListViewModel.price;
      boughtFlowerListCart.refresh();
      cartOrderList.refresh();
      updateCartOrder(cartId: cartOrderList[0].id);
    } else {
      Get.snackbar('Edit Flower', 'cant Minus count buy');
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
        deleteFlowerItemForCartOrder(  flowerItem: flowerItem, boughtFlowers: boughtFlowers);
        Navigator.of(context).pop();
        break;
    }
  }
  Future<void> editCountFlowerBuy({
    required FlowerListViewModel flowerItem, required int countBuy}) async {
    if (flowerItem.countInStock > 0) {
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
              (String error) => Get.snackbar('Register',
              'Your registration is not successfully code error:$error'),
              (String editFlower) {

            Get.snackbar('edit Flower', 'Your Add Flower is successfully');
          });
    } else {
      Get.snackbar('edit Flower', 'can not minus count in stock');
    }
    return;
  }
  Future<void> onSubmitPurchaseCartOrder() async {
    if (boughtFlowerListCart.isEmpty) {
      Get.snackbar('Add cart', 'Your cart  is empty');
    } else {
      final AddCartOrderDto dto = AddCartOrderDto(
          user: customerUser.first,
          dateTime: cartOrderList[0].dateTime,
          totalPrice: cartOrderList[0].totalPrice,
          boughtFlowers: boughtFlowerListCart);
      for (final item in boughtFlowerListCart) {
        editCountFlowerBuy( flowerItem: item.flowerListViewModel, countBuy:  item.buyCount);
      }
      Future.delayed(const Duration(seconds: 2), () async {
        final Either<String, String> resultOrException =
        (await _repository.addCartOrderToOrderList(dto));
        resultOrException.fold(
                (String error) => Get.snackbar('Register',
                'Your registration is not successfully code error:$error'),
                (String addRecord) {
              Get.snackbar('Add cart', 'Your Add order is successfully');
              deleteCartOrder( cartId: cartOrderList[0].id);
              boughtFlowerListCart.clear();
              cartOrderList.clear();
              cartCount.value = 0;
            });
      });
      Get.offAndToNamed(RouteNames.loadingPageFlower+RouteNames.loginPageFlower+RouteNames.customerHomePageFlower);
    }
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