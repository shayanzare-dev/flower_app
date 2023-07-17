import 'package:flower_app/src/pages/shared/grid_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../customer_home_page/models/flower_list_view_model.dart';
import '../repositories/customer_search_page_repository.dart';

class CustomerSearchPageController extends GetxController{
  final CustomerSearchPageRepository _repository = CustomerSearchPageRepository();
  final SharedPreferences _prefs = Get.find<SharedPreferences>();
  String customerUserEmail = '';
  final selectedIndex = RxInt(0);
  RxList<FlowerListViewModel> filteredFlowerList = RxList();
  final TextEditingController searchController = TextEditingController();
  List<String> dropDownButtonList = ['select a item'];
  Rx<String> selectedItemDropDown = Rx<String>('select a item');
  List<String> savedSelections = [];
  final RxList<GridItem> items = RxList<GridItem>([]);
  Rx<RangeValues> valuesRange = Rx<RangeValues>(const RangeValues(0, 1000));
  RxList<FlowerListViewModel> customerFlowerList = RxList();
  RxMap<int, int> flowerBuyCount = RxMap();

  var isLoading = false.obs;

  void showLoading() {
    isLoading.value = true;
  }

  void hideLoading() {
    isLoading.value = false;
  }

  @override
  void onInit() {
    Future.delayed(const Duration(seconds: 2), () {
      getFlowerList();
    });
    super.onInit();
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

  void clearSearchFilterFlowers({required BuildContext context}) {
    valuesRange = Rx<RangeValues>(const RangeValues(0, 1000));
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

  Future<void> getSearchFilterFlowerList(
      {required BuildContext context}) async {
    showLoading();
    filteredFlowerList.clear();
    Navigator.of(context).pop();
    if (selectedItemDropDown.value != 'select a item') {
      final categoryResult = await _repository.searchFilterCategory(
        category: selectedItemDropDown.value,
      );
      if (categoryResult.isLeft) {
        Get.snackbar('Login', 'user not found');
      } else if (categoryResult.isRight) {
        filteredFlowerList.addAll(categoryResult.right);
      }
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
    if (colorFilters != '') {
      final colorResult = await _repository.searchFilterColor(
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
      final result = await _repository.search(search);
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


}