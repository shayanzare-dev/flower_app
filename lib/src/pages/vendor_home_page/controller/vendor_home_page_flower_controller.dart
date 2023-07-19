import 'dart:convert';
import 'dart:io';

import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../flower_app.dart';
import '../../customer_home_page/models/bought_flowers_view_model.dart';
import '../../customer_home_page/models/cart_order_view_model.dart';
import '../../shared/grid_item.dart';
import '../models/add_flower_dto.dart';
import '../models/edit_flower_dto.dart';
import '../models/flower_list_view_model.dart';
import '../models/vendor_view_model.dart';
import '../repositories/vendor_home_page_flower_repository.dart';
import '../view/widget/bottom_navigation_bar_pages/bottom_navigation_bar_add_screen/bottom_navigation_bar_add_screen.dart';
import '../view/widget/bottom_navigation_bar_pages/bottom_navigation_bar_history_screen/bottom_navigation_bar_history_screen.dart';
import '../view/widget/bottom_navigation_bar_pages/bottom_navigation_bar_home_screen/bottom_navigation_bar_home_screen.dart';
import '../view/widget/bottom_navigation_bar_pages/bottom_navigation_bar_profile_screen/bottom_navigation_bar_profile_screen.dart';
import '../view/widget/bottom_navigation_bar_pages/bottom_navigation_bar_search_screen/bottom_navigation_bar_search_screen.dart';

class VendorHomePageFlowerController extends GetxController {
  SharedPreferences _prefs = Get.find<SharedPreferences>();
  final VendorHomePageFlowerRepository _repository =
      VendorHomePageFlowerRepository();
  final GlobalKey<FormState> addFlowerFormKey = GlobalKey<FormState>();
  final TextEditingController flowerNameController = TextEditingController();
  final TextEditingController flowerDescriptionController =
      TextEditingController();
  final TextEditingController flowerPriceController = TextEditingController();
  final TextEditingController flowerCountController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  RxList<FlowerListViewModel> filteredFlowerList = RxList();
  RxList<FlowerListViewModel> flowerList = RxList();
  RxList<VendorViewModel> vendorUser = RxList();
  final RxList<String> categoryChips = <String>[].obs;
  final TextEditingController categoryTextController = TextEditingController();
  final Rx<Color> selectedColor = const Color(0xff04927c).obs;
  Color selectedColors = const Color(0xff04927c);
  final selectedIndexNavBar = RxInt(0);
  List<String> savedSelections = [];
  final RxList<GridItem> colorItems = RxList<GridItem>([]);
  File? imageFile;
  String base64Image = "";
  String vendorUserEmail = '';
  List<String> dropDownButtonList = ['select a item'];
  Rx<String> selectedItemDropDown = Rx<String>('select a item');
  Rx<RangeValues> valuesRange = Rx<RangeValues>(RangeValues(0, 1000));

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
    _prefs = Get.find<SharedPreferences>();
    Future.delayed(const Duration(seconds: 1), () {
      vendorUserEmail = _prefs.getString('userEmail') ?? 'test@gmail.com';
    });
    Future.delayed(const Duration(seconds: 2), () {
      getProfileUser();
      getFlowerList();
      getOrderListVendorHistory();
    });

    super.onInit();
  }

  @override
  void dispose() {
    categoryTextController.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Future<void> refresh() async {
    showLoading();
    _prefs = Get.find<SharedPreferences>();
    Future.delayed(const Duration(seconds: 1), () {
      vendorUserEmail = _prefs.getString('userEmail') ?? 'test@gmail.com';
    });
    Future.delayed(const Duration(seconds: 2), () {
      getProfileUser();
      getFlowerList();
      getOrderListVendorHistory();
    });

    hideLoading();
    Get.snackbar('Refresh', 'Refresh is successfully');
  }

  //Home Screen
  static List<Widget> widgetOptionsNavBar = <Widget>[
    const HomeScreen(),
    const AddScreen(),
    const SearchScreen(),
    const HistoryScreen(),
    ProfileScreen(),
  ];

  void onItemTappedNavBar({required int index}) {
    selectedIndexNavBar.value = index;
  }

  Future<void> editCountFlowerPlus(
      {required FlowerListViewModel flowerItem}) async {
    final EditFlowerDto dto = EditFlowerDto(
        id: flowerItem.id,
        price: flowerItem.price,
        shortDescription: flowerItem.shortDescription,
        countInStock: flowerItem.countInStock + 1,
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
    final Either<String, FlowerListViewModel> resultOrException =
        (await _repository.editFlower(dto, flowerItem.id));
    resultOrException.fold(
        (String error) => Get.snackbar('Register',
            'Your registration is not successfully code error:$error'),
        (FlowerListViewModel addRecord) {
      getFlowerList();
      Get.snackbar('edit Flower', 'Your Add Flower is successfully');
    });
    return;
  }

  Future<void> editCountFlowerMinus(
      {required FlowerListViewModel flowerItem}) async {
    if (flowerItem.countInStock > 0) {
      final EditFlowerDto dto = EditFlowerDto(
          id: flowerItem.id,
          price: flowerItem.price,
          shortDescription: flowerItem.shortDescription,
          countInStock: flowerItem.countInStock - 1,
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
      final Either<String, FlowerListViewModel> resultOrException =
          (await _repository.editFlower(dto, flowerItem.id));
      resultOrException.fold(
          (String error) => Get.snackbar('Register',
              'Your registration is not successfully code error:$error'),
          (FlowerListViewModel addRecord) {
        getFlowerList();
        Future.delayed(const Duration(seconds: 3), () {});
        Get.snackbar('edit Flower', 'Your Add Flower is successfully');
      });
    } else {
      Get.snackbar('edit Flower', 'can not minus count in stock');
    }
    return;
  }

  Future<void> deleteFlowerItem(
      {required FlowerListViewModel flowerItem}) async {
    final result = await _repository.deleteFlowerItem(flowerItem.id);
    if (result.right == 'success') {
      getFlowerList();
      Get.snackbar('done', result.right);
    } else {
      Get.snackbar('error', result.left);
    }
  }

  void alertDialogSelect({
    required int itemSelect,
    required FlowerListViewModel flowerItem,
    required BuildContext context,
  }) {
    switch (itemSelect) {
      case 1:
        break;
      case 2:
        deleteFlowerItem(flowerItem: flowerItem);
        Navigator.of(context).pop();
        break;
    }
  }

  Future<void> getProfileUser() async {
    showLoading();
    vendorUser.clear();
    final result = await _repository.getVendorUser(vendorUserEmail);
    if (result.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (result.isRight) {
      vendorUser.addAll(result.right);
    }
    hideLoading();
  }

  Future<String> userEmail() async {
    return _prefs.getString('userEmail') ?? 'test@gmail.com';
  }

  List<int> priceList = [];
  double maxPrice = 0.0;

  void maxPrices() {
    priceList.sort();
    maxPrice = priceList.last.toDouble();
    valuesRange = Rx<RangeValues>(RangeValues(0, maxPrice));
  }

  Future<void> getFlowerList() async {
    showLoading();
    flowerList.clear();
    colorItems.clear();
    getFilteredSuggestions.clear();
    dropDownButtonList.clear();
    dropDownButtonList = ['select a item'];
    selectedItemDropDown = Rx<String>('select a item');
    final result = await _repository.getFlowerList(vendorUserEmail);
    if (result.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (result.isRight) {
      flowerList.addAll(result.right);
      for (final item in result.right) {
        priceList.add(item.price);
        colorItems.add(GridItem(color: Color(item.color)));
        for (final categoryItem in item.category) {
          dropDownButtonList.add(categoryItem.toString());
          getFilteredSuggestions.add(categoryItem.toString());
        }
      }
    }
    maxPrices();
    hideLoading();
  }

  //Add Screen

  RxList<String> suggestions = <String>[].obs;

  void updateSuggestions(String text) {
    if (text == ''){
      suggestions.clear();
    }else{
      List<String> filteredList = getFilteredSuggestions
          .where((suggestion) => suggestion.startsWith(text))
          .toList();
      suggestions.value = filteredList;
    }
  }
  List<String> getFilteredSuggestions = [];

  void addChip() {
    final text = categoryTextController.text.trim();
    if (text.isNotEmpty && !categoryChips.contains(text)) {
      categoryChips.add(text);
      categoryTextController.clear();
    }
  }

  void removeChip({required int index}) => categoryChips.removeAt(index);

  Future<void> getImage({required ImageSource imageSource}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      update();
      if (imageFile != null) {
        List<int> imageBytes = await pickedFile.readAsBytes();
        base64Image = base64Encode(imageBytes);
      }
    } else {
      Get.snackbar('Image', 'No image selected.');
    }
  }

  void changeColor({required Color color}) {
    selectedColor.value = color;
    selectedColors = color;
  }

  Future<void> onSubmitAddFlower() async {
    if (!addFlowerFormKey.currentState!.validate()) {
      Get.snackbar('Add Flower', 'Your must be enter required field');
      return;
    }
    showLoading();
    final AddFlowerDto dto = AddFlowerDto(
        price: int.parse(flowerPriceController.text),
        shortDescription: flowerDescriptionController.text,
        countInStock: int.parse(flowerCountController.text),
        category: categoryChips,
        name: flowerNameController.text,
        color: selectedColors.value,
        image: base64Image,
        vendorUser: VendorViewModel(
            id: vendorUser.first.id,
            passWord: vendorUser.first.passWord,
            firstName: vendorUser.first.firstName,
            lastName: vendorUser.first.lastName,
            email: vendorUser.first.email,
            image: vendorUser.first.image,
            userType: vendorUser.first.userType));
    final Either<String, FlowerListViewModel> resultOrException =
        (await _repository.addFlower(dto));
    resultOrException.fold((String error) {
      hideLoading();
      return Get.snackbar('Register',
          'Your registration is not successfully code error:$error');
    }, (FlowerListViewModel addRecord) async {
      Get.snackbar('Add Flower', 'Your Add Flower is successfully');
      refresh();
      hideLoading();
      addFlowerFormKey.currentState?.reset();
    });

    return;
  }

  String? validateFlowerName({required String value}) {
    if (value.isEmpty || value.length < 2) {
      return "flower name must be of 2 characters";
    }
    return null;
  }

  String? validateFlowerDescription({required String value}) {
    if (value.isEmpty || value.length < 10) {
      return "flower description must be of 10 characters";
    }
    return null;
  }

  String? validateFlowerPrice({required String value}) {
    if (value.isEmpty || value.length < 2) {
      return "flower price must be of 2 characters";
    }
    return null;
  }

  String? validateFlowerCount({required String value}) {
    if (value.isEmpty) {
      return "flower count is required ";
    }
    return null;
  }

  //Search screen
  RangeValues get values => valuesRange.value;

  void setValues({required RangeValues rangeValues}) {
    valuesRange.value = rangeValues;
  }

  void clearSearchFilterFlowers({required BuildContext context}) {
    valuesRange = Rx<RangeValues>(RangeValues(0, maxPrice));
    selectedItemDropDown.value = 'select a item';
    for (int i = 0; i < savedSelections.length; i++) {
      colorItems[i].isSelected = false;
    }
    List<String> selections =
        colorItems.map((item) => item.isSelected.toString()).toList();
    _prefs.setStringList('selections', selections);
    savedSelections = _prefs.getStringList('selections') ?? [];
    colorItems.refresh();
    Navigator.of(context).pop();
  }

  Future<void> getSearchFilterFlowerList(
      {required BuildContext context}) async {
    filteredFlowerList.clear();
    Navigator.of(context).pop();
    showLoading();
    if (selectedItemDropDown.value != 'select a item') {
      final categoryResult = await _repository.searchFilterCategory(
        category: selectedItemDropDown.value,
        email: vendorUserEmail,
      );
      if (categoryResult.isLeft) {
        Get.snackbar('Login', 'user not found');
      } else if (categoryResult.isRight) {
        filteredFlowerList.addAll(categoryResult.right);
        for (final items in filteredFlowerList) {
          filteredFlowerList.removeWhere((item) => item.id == items.id);
          filteredFlowerList.addAll(categoryResult.right);
        }
        hideLoading();
      }
    }
    if (valuesRange.value.start != 0 || valuesRange.value.end != maxPrice) {
      final priceResult = await _repository.searchFilterPriceRange(
        email: vendorUserEmail,
        min: valuesRange.value.start.toString(),
        max: valuesRange.value.end.toString(),
      );
      if (priceResult.isLeft) {
        Get.snackbar('Login', 'user not found');
      } else if (priceResult.isRight) {
        if (filteredFlowerList.isEmpty) {
          filteredFlowerList.addAll(priceResult.right);
        } else {
          filteredFlowerList.removeWhere((item) => item.id == item.id);
          filteredFlowerList.addAll(priceResult.right);
        }
        hideLoading();
      }
    }


    List<int> colorFilter = [];
    for (int i = 0; i < savedSelections.length; i++) {
      colorItems[i].isSelected = savedSelections[i] == 'true';
      if (colorItems[i].isSelected) {
        colorFilter.add(colorItems[i].color.value);
      }
    }
    String colorFilters =
        colorFilter.map((color) => 'color_like=$color').join('&');
    if (colorFilters != '') {
      final colorResult = await _repository.searchFilterColor(
        email: vendorUserEmail,
        colors: colorFilters,
      );
      if (colorResult.isLeft) {
        Get.snackbar('Login', 'user not found');
      } else if (colorResult.isRight) {
        filteredFlowerList.addAll(colorResult.right);
        for (final items in filteredFlowerList) {
          filteredFlowerList.removeWhere((item) => item.id == items.id);
          filteredFlowerList.addAll(colorResult.right);
        }
        hideLoading();
      }
    }
    hideLoading();
  }

  Future<void> getSearchFlowerList({required String search}) async {
    showLoading();
    if (search != '') {
      final result = await _repository.search(search, vendorUserEmail);
      if (result.isLeft) {
        Get.snackbar('Login', 'user not found');
      } else if (result.isRight) {
        filteredFlowerList.addAll(result.right);
      }
    } else {
      filteredFlowerList.clear();
    }
    hideLoading();
  }

  void colorToggleSelection({required int colorToggleIndex}) {
    colorItems[colorToggleIndex].isSelected =
        !colorItems[colorToggleIndex].isSelected;
    List<String> selections =
        colorItems.map((item) => item.isSelected.toString()).toList();
    _prefs.setStringList('selections', selections);
    savedSelections = _prefs.getStringList('selections') ?? [];
    for (int i = 0; i < savedSelections.length; i++) {
      colorItems[i].isSelected = savedSelections[i] == 'true';
      colorItems.refresh();
    }
  }

  void clearFilteredFlowerList() {
    filteredFlowerList.clear();
    searchController.clear();
  }

  //History Screen
  Future<void> getOrderListVendorHistory() async {
    showLoading();
    boughtFlowerList.clear();
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

  void goToEditFlowerPage({required FlowerListViewModel flowerItem}) {
    Get.toNamed(
        RouteNames.loadingPageFlower +
            RouteNames.loginPageFlower +
            RouteNames.vendorHomePageFlower +
            RouteNames.editFlowerPage,
        arguments: flowerItem);
  }

  void clearLoginStatus() async {
    await _prefs.clear();
  }

  void goToLoginPage() {
    Get.toNamed(RouteNames.loadingPageFlower + RouteNames.loginPageFlower);
  }
}
