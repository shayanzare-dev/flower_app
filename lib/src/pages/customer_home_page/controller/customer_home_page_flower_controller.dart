import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../flower_app.dart';
import '../../vendor_home_page/models/vendor_view_model.dart';
import '../models/add_order_dto.dart';
import '../models/bought_flowers_view_model.dart';
import '../models/cart_order_view_model.dart';
import '../models/edit_flower_dto.dart';
import '../models/flower_list_view_model.dart';
import '../models/user_view_model.dart';
import '../repositories/customer_home_page_flower_repository.dart';
import '../view/widget/bottom_navigation_bar_customer_cart_screen.dart';
import '../view/widget/bottom_navigation_bar_customer_history_screen.dart';
import '../view/widget/bottom_navigation_bar_customer_home_screen.dart';
import '../view/widget/bottom_navigation_bar_customer_profile_screen.dart';
import '../view/widget/bottom_navigation_bar_customer_search_screen.dart';

class CustomerHomePageFlowerController extends GetxController {
  final CustomerHomePageFlowerRepository _repository =
      CustomerHomePageFlowerRepository();
  RxList<UserViewModel> customerUser = RxList();
  RxList<FlowerListViewModel> customerFlowerList = RxList();
  RxMap<int, int> flowerBuyCount = RxMap();

  RxList<BoughtFlowers> boughtFlowerListCart = RxList();
  RxList<CartOrder> cartOrderList = RxList();

  RxList<BoughtFlowers> boughtFlowerList = RxList();
  RxList<CartOrder> boughtOrderList = RxList();

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
      getOrderList();
    });
    Future.delayed(const Duration(seconds: 1), () {
      userEmail().then((userEmail) {
        customerUserEmail = userEmail;
      });
    });
    super.onInit();
  }

  int totalPrice = 0;

  void addFlowerToBoughtFlowers(FlowerListViewModel flowerItem) {
    int? buyCount = flowerBuyCount[flowerItem.id];
    if (buyCount == 0) {
      Get.snackbar('Add Flower', 'can not add to cart');
    } else {
      String dateTime = DateTime.now().toString();
      int sumBuyPrice = buyCount! * flowerItem.price;
      BoughtFlowers boughtFlowers = BoughtFlowers(
          flowerListViewModel: flowerItem,
          buyCount: buyCount,
          sumBuyPrice: sumBuyPrice,
          dateTime: dateTime,
          user: customerUser[0]);
      boughtFlowerListCart.add(boughtFlowers);

      editCountFlowerBuy(flowerItem, buyCount);
      for (final item in boughtFlowerListCart) {
        if (item.flowerListViewModel.id == flowerItem.id) {
          totalPrice = totalPrice + item.sumBuyPrice;
        }
      }

      CartOrder cartOrder = CartOrder(
          user: customerUser.first,
          dateTime: dateTime,
          totalPrice: totalPrice,
          boughtFlowers: boughtFlowerListCart);
      if (cartOrderList.isEmpty) {
        cartOrderList.add(cartOrder);
        Get.snackbar('Add Flower', 'add to cart');
        flowerBuyCount[flowerItem.id] = 0;
      } else {
        cartOrderList.clear();
        cartOrderList.add(cartOrder);
        Get.snackbar('Add Flower', 'add to cart');
        flowerBuyCount[flowerItem.id] = 0;
      }
    }
  }

  void deleteFlowerItem(
    FlowerListViewModel flowerItem,
    BoughtFlowers boughtFlowers,
  ) {
    final int index = boughtFlowerListCart.indexOf(boughtFlowers);
    editCountFlowerCancelBuy(flowerItem);
    int sumBuyPrice = boughtFlowerListCart[index].sumBuyPrice;
    boughtFlowerListCart.removeAt(index);
    cartOrderList[0].totalPrice = sumBuyPrice;
    totalPrice = sumBuyPrice;
  }

  void editFlowerCountItemPlus(BoughtFlowers boughtFlowers) {
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
    } else {
      Get.snackbar('Edit Flower', 'cant plus count buy');
    }
  }

  void editFlowerCountItemMinus(BoughtFlowers boughtFlowers) {
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
    } else {
      Get.snackbar('Edit Flower', 'cant Minus count buy');
    }
  }

  void alertDialogSelect({
    required BoughtFlowers boughtFlowers,
    required int itemSelect,
    required FlowerListViewModel flowerItem,
    required BuildContext context,
  }) {
    switch (itemSelect) {
      case 1:
        break;
      case 2:
        deleteFlowerItem(flowerItem, boughtFlowers);
        Navigator.of(context).pop();
        break;
    }
  }

  Future<void> editCountFlowerCancelBuy(FlowerListViewModel flowerItem) async {
    final EditFlowerDto dto = EditFlowerDto(
        id: flowerItem.id,
        price: flowerItem.price,
        shortDescription: flowerItem.shortDescription,
        countInStock: flowerItem.countInStock,
        category: flowerItem.category,
        name: flowerItem.name,
        color: flowerItem.color,
        image: flowerItem.image,
        vendorUser: vendorViewModel(
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
      getFlowerList();
      Get.snackbar('edit Flower', 'Your Add Flower is successfully');
    });
    return;
  }

  Future<void> editCountFlowerBuy(
      FlowerListViewModel flowerItem, int countBuy) async {
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
          vendorUser: vendorViewModel(
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
        getFlowerList();
        Get.snackbar('edit Flower', 'Your Add Flower is successfully');
      });
    } else {
      Get.snackbar('edit Flower', 'can not minus count in stock');
    }
    return;
  }

  Future<void> onSubmitPurchaseCartOrder() async {
    final CartOrderDto dto = CartOrderDto(
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
      boughtFlowerListCart.clear();
      cartOrderList.clear();
    });
    return;
  }

  void editBuyCountFlowerPlus(FlowerListViewModel flowerItem) {
    if (flowerItem.countInStock > flowerBuyCount[flowerItem.id]!) {
      flowerBuyCount[flowerItem.id] = (flowerBuyCount[flowerItem.id]! + 1);
    } else {
      Get.snackbar('edit Flower', 'can not plus count in stock');
    }
    return;
  }

  void editBuyCountFlowerMinus(FlowerListViewModel flowerItem) {
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

  Future<void> getOrderList() async {
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
