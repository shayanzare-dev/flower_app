import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/grid_item.dart';
import '../../vendor_home_page/models/flower_list_view_model.dart';
import '../repositories/vendor_search_page_repository.dart';

class VendorSearchPageController extends GetxController{
  final SharedPreferences _prefs = Get.find<SharedPreferences>();
  final VendorSearchPageRepository _repository =
  VendorSearchPageRepository();
  List<String> savedSelections = [];
  final RxList<GridItem> items = RxList<GridItem>([]);
  List<String> dropDownButtonList = ['select a item'];
  Rx<String> selectedItemDropDown = Rx<String>('select a item');
  Rx<RangeValues> valuesRange = Rx<RangeValues>(const RangeValues(0, 1000));
  RxList<FlowerListViewModel> filteredFlowerList = RxList();
  String vendorUserEmail = '';
  final TextEditingController searchController = TextEditingController();
  RxList<FlowerListViewModel> flowerList = RxList();
  var isLoading = false.obs;
  void showLoading() {
    isLoading.value = true;
  }
  void hideLoading() {
    isLoading.value = false;
  }
  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {
      getFlowerList();
    });
    Future.delayed(const Duration(seconds: 1), () {
      userEmail().then((userEmail) {
        vendorUserEmail = userEmail;
      });
    });
  }

  Future<void> getFlowerList() async {
    flowerList.clear();
    items.clear();
    final result = await _repository.getFlowerList(vendorUserEmail);
    if (result.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (result.isRight) {
      flowerList.addAll(result.right);
      for (final item in result.right) {
        items.add(GridItem(color: Color(item.color)));
        for (final categoryItem in item.category) {
          dropDownButtonList.add(categoryItem.toString());
        }
      }
    }
  }

  Future<String> userEmail() async {
    return _prefs.getString('userEmail') ?? 'test@gmail.com';
  }

  RangeValues get values => valuesRange.value;
  void setValues({required RangeValues rangeValues}) {
    valuesRange.value = rangeValues;
  }

  void clearSearchFilterFlowers({required BuildContext context}) {
    valuesRange = Rx<RangeValues>( const RangeValues(0, 1000));
    selectedItemDropDown.value = 'select a item';
    for (int i = 0; i < savedSelections.length; i++) {
      items[i].isSelected = false;
    }
    List<String> selections =
    items.map((item) => item.isSelected.toString()).toList();
    _prefs.setStringList('selections', selections);
    savedSelections = _prefs.getStringList('selections') ?? [];
    items.refresh();
    Navigator.of(context).pop();

  }
  Future<void> getSearchFilterFlowerList({required BuildContext context}) async {
    filteredFlowerList.clear();
    Navigator.of(context).pop();
    showLoading();
    if(selectedItemDropDown.value != 'select a item'){
      final categoryResult = await _repository.searchFilterCategory(
        category: selectedItemDropDown.value,
        email: vendorUserEmail,
      );
      if (categoryResult.isLeft) {
        Get.snackbar('Login', 'user not found');
      } else if (categoryResult.isRight) {
        filteredFlowerList.addAll(categoryResult.right);
      }
    }
    final priceResult = await _repository.searchFilterPriceRange(
      email: vendorUserEmail,
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
    if(colorFilters != ''){
      final colorResult = await _repository.searchFilterColor(
        email: vendorUserEmail,
        colors: colorFilters,
      );
      if (colorResult.isLeft) {
        Get.snackbar('Login', 'user not found');
      } else if (colorResult.isRight) {
        filteredFlowerList.addAll(colorResult.right);
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
    items[colorToggleIndex].isSelected = !items[colorToggleIndex].isSelected;
    List<String> selections =
    items.map((item) => item.isSelected.toString()).toList();
    _prefs.setStringList('selections', selections);
    savedSelections = _prefs.getStringList('selections') ?? [];
    for (int i = 0; i < savedSelections.length; i++) {
      items[i].isSelected = savedSelections[i] == 'true';
      items.refresh();
    }
  }

  void clearFilteredFlowerList() {
    filteredFlowerList.clear();
    searchController.clear();
  }

}