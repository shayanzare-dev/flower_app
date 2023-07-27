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
  final RxList<GridItem> colorItems = RxList<GridItem>([]);
  Rx<RangeValues> valuesRange = Rx<RangeValues>(const RangeValues(0, 1));
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
    showLoading();
    colorItems.clear();
    dropDownButtonList.clear();
    customerFlowerList.clear();
    dropDownButtonList = ['select a item'];
    selectedItemDropDown = Rx<String>('select a item');
    final result = await _repository.getFlowerList();
    if (result.isLeft) {
      Get.snackbar('Flower List', 'Flowers not found');
    } else if (result.isRight) {
      customerFlowerList.addAll(result.right);
      for (final item in result.right) {
        flowerBuyCount[item.id] = 0;
        colorItems.add(GridItem(color: Color(item.color)));
        String inputString = item.price;
        int intValue = int.parse(inputString.replaceAll(',', ''));
        priceList.add(intValue);
        for (final categoryItem in item.category) {
          if (!dropDownButtonList.contains(categoryItem.toString())) {
            dropDownButtonList.add(categoryItem.toString());
          }
        }
      }
    }
    if (customerFlowerList.isNotEmpty) {
      maxPrices();
    }
    hideLoading();
  }
  List<int> priceList = [];
  double maxPrice = 2.0;

  void maxPrices() {
    priceList.sort();
    maxPrice = priceList.last.toDouble();
    valuesRange = Rx<RangeValues>(RangeValues(0, maxPrice));
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
    colorItems[colorIndex].isSelected = !colorItems[colorIndex].isSelected;
    List<String> selections =
    colorItems.map((item) => item.isSelected.toString()).toList();
    _prefs.setStringList('selections', selections);
    savedSelections = _prefs.getStringList('selections') ?? [];
    for (int i = 0; i < savedSelections.length; i++) {
      colorItems[i].isSelected = savedSelections[i] == 'true';
      colorItems.refresh();
    }
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
    List<int> colorFilter = [];
    for (int i = 0; i < savedSelections.length; i++) {
      colorItems[i].isSelected = savedSelections[i] == 'true';
      if (colorItems[i].isSelected) {
        colorFilter.add(colorItems[i].color.value);
      }
    }
    String colorFilters = colorFilter.map((color) => 'color=$color').join('&');

    if (selectedItemDropDown.value != 'select a item' && colorFilters != '') {
      final searchFiltersResult = await _repository.searchFilters(
        category: selectedItemDropDown.value,
        colors: colorFilters,
        min: valuesRange.value.start.toString(),
        max: valuesRange.value.end.toString(),
      );
      if (searchFiltersResult.isLeft) {
        Get.snackbar('Login', 'user not found');
      } else if (searchFiltersResult.isRight) {
        filteredFlowerList.clear();
        filteredFlowerList.addAll(searchFiltersResult.right);
        hideLoading();
      }
    } else if (selectedItemDropDown.value != 'select a item') {
      final searchFiltersResult = await _repository.searchFilterCategoryPrice(
        category: selectedItemDropDown.value,
        min: valuesRange.value.start.toString(),
        max: valuesRange.value.end.toString(),
      );
      if (searchFiltersResult.isLeft) {
        Get.snackbar('Login', 'user not found');
      } else if (searchFiltersResult.isRight) {
        filteredFlowerList.clear();
        filteredFlowerList.addAll(searchFiltersResult.right);
        hideLoading();
      }
    } else if (colorFilters != '') {
      final searchFiltersResult = await _repository.searchFilterColorPrice(
        colors: colorFilters,
        min: valuesRange.value.start.toString(),
        max: valuesRange.value.end.toString(),
      );
      if (searchFiltersResult.isLeft) {
        Get.snackbar('Login', 'user not found');
      } else if (searchFiltersResult.isRight) {
        filteredFlowerList.clear();
        filteredFlowerList.addAll(searchFiltersResult.right);
        hideLoading();
      }
    } else {
      final priceResult = await _repository.searchFilterPriceRange(
        min: valuesRange.value.start.toString(),
        max: valuesRange.value.end.toString(),
      );
      if (priceResult.isLeft) {
        Get.snackbar('Login', 'user not found');
      } else if (priceResult.isRight) {
        filteredFlowerList.clear();
        filteredFlowerList.addAll(priceResult.right);
        hideLoading();
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