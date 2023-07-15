import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../flower_app.dart';
import '../../shared/grid_item.dart';
import '../../vendor_home_page/models/vendor_view_model.dart';
import '../models/add_cart_order_dto.dart';
import '../models/bought_flowers_view_model.dart';
import '../models/cart_order_view_model.dart';
import '../models/edit_flower_dto.dart';
import '../models/edit_order_dto.dart';
import '../models/flower_list_view_model.dart';
import '../models/user_view_model.dart';
import '../repositories/customer_home_page_flower_repository.dart';
import '../view/widget/bottom_navigation_bar_customer_pages/bottom_navigation_bar_customer_cart_screen/bottom_navigation_bar_customer_cart_screen.dart';
import '../view/widget/bottom_navigation_bar_customer_pages/bottom_navigation_bar_customer_history_screen/bottom_navigation_bar_customer_history_screen.dart';
import '../view/widget/bottom_navigation_bar_customer_pages/bottom_navigation_bar_customer_home_screen/bottom_navigation_bar_customer_home_screen.dart';
import '../view/widget/bottom_navigation_bar_customer_pages/bottom_navigation_bar_customer_profile_screen/bottom_navigation_bar_customer_profile_screen.dart';
import '../view/widget/bottom_navigation_bar_customer_pages/bottom_navigation_bar_customer_search_screen/bottom_navigation_bar_customer_search_screen.dart';

class CustomerHomePageFlowerController extends GetxController {
  final CustomerHomePageFlowerRepository _repository = CustomerHomePageFlowerRepository();
  final SharedPreferences _prefs = Get.find<SharedPreferences>();
  RxList<UserViewModel> customerUser = RxList();
  RxList<FlowerListViewModel> customerFlowerList = RxList();
  RxMap<int, int> flowerBuyCount = RxMap();
  RxList<BoughtFlowersViewModel> boughtFlowerListCart = RxList();
  RxList<CartOrderViewModel> cartOrderList = RxList();
  RxList<BoughtFlowersViewModel> boughtFlowerList = RxList();
  RxList<CartOrderViewModel> boughtOrderList = RxList();
  RxInt cartCount = 0.obs;
  String customerUserEmail = '';
  final selectedIndex = RxInt(0);
  RxList<FlowerListViewModel> filteredFlowerList = RxList();
  final TextEditingController searchController = TextEditingController();
  List<String> dropDownButtonList = ['select a item'];
  Rx<String> selectedItemDropDown = Rx<String>('select a item');
  List<String> savedSelections = [];
  final RxList<GridItem> items = RxList<GridItem>([]);
  Rx<RangeValues> valuesRange = Rx<RangeValues>(const RangeValues(0, 1000));
  int totalPrice = 0;

  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 2), () {
      getCustomerUser();
      getFlowerList();
      getOrderCart();
      getOrderList();
    });
    Future.delayed(const Duration(seconds: 1), () {
      userEmail().then((userEmail) {
        customerUserEmail = userEmail;
      });
    });
    super.onInit();
  }
  @override
  Future<void> refresh() async {
    Future.delayed(const Duration(seconds: 2), () {
      getCustomerUser();
      getFlowerList();
      getOrderCart();
      getOrderList();
    });
    Future.delayed(const Duration(seconds: 1), () {
      userEmail().then((userEmail) {
        customerUserEmail = userEmail;
      });
    });
  }

  //Home Screen
  static List<Widget> widgetOptionsNavBar = <Widget>[
    CustomerHomeScreen(),
    const CustomerCartScreen(),
    CustomerSearchScreen(),
    CustomerHistoryScreen(),
    CustomerProfileScreen(),
  ];
  void onItemTappedNavBar({required int navBarIndex}) {
    selectedIndex.value = navBarIndex;
  }
  Future<String> userEmail() async {
    return _prefs.getString('userEmail') ?? 'test@gmail.com';
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
  Future<void> getFlowerList() async {
    customerFlowerList.clear();
    final result = await _repository.getFlowerList();
    if (result.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (result.isRight) {
      customerFlowerList.addAll(result.right);
      for (final item in result.right) {
        flowerBuyCount[item.id] = 0;
        items.add(GridItem(color: Color(item.color)));
        for (final categoryItem in item.category) {
          dropDownButtonList.add(categoryItem.toString());
        }
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

  //Cart Screen
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
            getFlowerList();
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

  //Search Screen
  RangeValues get values => valuesRange.value;
  void setRangeValues({required RangeValues rangeValues}) {
    valuesRange.value = rangeValues;
  }
  void clearFilteredFlowerList() {
    filteredFlowerList.clear();
    searchController.clear();
  }
  void colorToggleSelection({required int colorIndex}) {
    items[colorIndex].isSelected = !items[colorIndex].isSelected;
    List<String> selections =
    items.map((item) => item.isSelected.toString()).toList();
    _prefs.setStringList('selections', selections);
    savedSelections = _prefs.getStringList('selections') ?? [];
    for (int i = 0; i < savedSelections.length; i++) {
      items[i].isSelected = savedSelections[i] == 'true';
      items.refresh();
    }
  }
  void clearSearchFilterFlowers() {
    valuesRange = Rx<RangeValues>(const RangeValues(0, 1000));
    selectedItemDropDown.value = 'select a item';
    for (int i = 0; i < savedSelections.length; i++) {
      items[i].isSelected = false;
    }
    List<String> selections =
    items.map((item) => item.isSelected.toString()).toList();
    _prefs.setStringList('selections', selections);
    items.refresh();
  }
  Future<void> getSearchFilterFlowerList() async {
    filteredFlowerList.clear();
    final categoryResult = await _repository.searchFilterCategory(
      category: selectedItemDropDown.value,
    );
    if (categoryResult.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (categoryResult.isRight) {
      filteredFlowerList.addAll(categoryResult.right);
    }
    final priceResult = await _repository.searchFilterPriceRange(
      min: valuesRange.value.start.toString(),
      max: valuesRange.value.end.toString(),
    );
    if (priceResult.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (priceResult.isRight) {
      filteredFlowerList.addAll(priceResult.right);
    }
    List<int> colorFilter = [];
    for (int i = 0; i < savedSelections.length; i++) {
      items[i].isSelected = savedSelections[i] == 'true';
      if (items[i].isSelected) {
        colorFilter.add(items[i].color.value);
      }
    }
    String colorFilters =
    colorFilter.map((color) => 'color_like=$color').join('&');
    final colorResult = await _repository.searchFilterColor(
      colors: colorFilters,
    );
    if (colorResult.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (colorResult.isRight) {
      filteredFlowerList.addAll(colorResult.right);
    }
  }
  Future<void> getSearchFlowerList({required String search}) async {
    if (search != '') {
      final result = await _repository.search(search);
      if (result.isLeft) {
        Get.snackbar('Login', 'user not found');
      } else if (result.isRight) {
        filteredFlowerList.addAll(result.right);
      }
    } else {
      filteredFlowerList.clear();
    }
  }

  //History Screen
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


  void goToLoginPage() {
    Get.offAndToNamed(RouteNames.loginPageFlower);
  }
}
