import 'package:flower_app/src/pages/shared/grid_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_workers/utils/debouncer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../customer_home_page/models/flower_list_view_model.dart';
import '../repositories/customer_search_page_repository.dart';

class CustomerSearchPageController extends GetxController {
  final CustomerSearchPageRepository _repository =
      CustomerSearchPageRepository();
  SharedPreferences _prefs = Get.find<SharedPreferences>();
  String customerUserEmail = '';
  final selectedIndex = RxInt(0);
  RxList<FlowerListViewModel> filteredFlowerList = RxList();
  final TextEditingController searchController = TextEditingController();
  List<String> dropDownButtonList = ['select a item'];
  Rx<String> selectedItemDropDown = Rx<String>('select a item');
  List<String> savedSelections = [];
  final RxList<ColorGridItem> colorItems = RxList<ColorGridItem>([]);
  Rx<RangeValues> valuesRange = Rx<RangeValues>(const RangeValues(0, 1));
  RxList<FlowerListViewModel> customerFlowerList = RxList();
  RxMap<int, int> flowerBuyCount = RxMap();

  final debouncer = Debouncer(delay: const Duration(seconds: 1));

  RxBool isLoading = false.obs;

  void showLoading() {
    isLoading.value = true;
  }

  void hideLoading() {
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    _prefs = Get.find<SharedPreferences>();
    customerUserEmail = _prefs.getString('userEmail') ?? 'test@gmail.com';
    getFlowerList();
    getColorList();
    getCategoryList();
  }

  Future<void> getFlowerList() async {
    showLoading();
    customerFlowerList.clear();
    final result = await _repository.getFlowerList();
    if (result.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (result.isRight) {
      customerFlowerList.addAll(result.right);
      for (final item in result.right) {
        priceList.add(item.price);
      }
    }
    if (customerFlowerList.isNotEmpty) {
      maxPrices();
    }
    hideLoading();
  }

  Future<void> getColorList() async {
    showLoading();
    colorItems.clear();
    final result = await _repository.getColorList();
    if (result.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (result.isRight) {
      for (final item in result.right) {
        colorItems.add(ColorGridItem(color: Color(item.color)));
      }
    }
    hideLoading();
  }

  Future<void> getCategoryList() async {
    dropDownButtonList.clear();
    dropDownButtonList = ['select a item'];
    selectedItemDropDown = Rx<String>('select a item');
    final result = await _repository.getCategoryList();
    if (result.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (result.isRight) {
      for (final item in result.right) {
        for (final categoryItem in item.category) {
          dropDownButtonList.add(categoryItem);
        }
      }
    }
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

  void clearSearchFilterFlowers({required BuildContext context}) {
    filteredFlowerList.clear();
    searchController.clear();
    valuesRange = Rx<RangeValues>(RangeValues(0, maxPrice));
    filteredFlowerList.clear();
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

  void clearSearchFilterFlowersTextField() {
    filteredFlowerList.clear();
    searchController.clear();
    valuesRange = Rx<RangeValues>(RangeValues(0, maxPrice));
    filteredFlowerList.clear();
    selectedItemDropDown.value = 'select a item';
    for (int i = 0; i < savedSelections.length; i++) {
      colorItems[i].isSelected = false;
    }
    List<String> selections =
        colorItems.map((item) => item.isSelected.toString()).toList();
    _prefs.setStringList('selections', selections);
    savedSelections = _prefs.getStringList('selections') ?? [];
    colorItems.refresh();
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
    debouncer(() async {
      showLoading();
      List<int> colorFilter = [];
      for (int i = 0; i < savedSelections.length; i++) {
        colorItems[i].isSelected = savedSelections[i] == 'true';
        if (colorItems[i].isSelected) {
          colorFilter.add(colorItems[i].color.value);
        }
      }
      String colorFilters =
          colorFilter.map((color) => 'color=$color').join('&');

      if (selectedItemDropDown.value != 'select a item' && colorFilters != '') {
        final searchFiltersResult =
            await _repository.searchTextFieldWithFilters(
          category: selectedItemDropDown.value,
          colors: colorFilters,
          min: valuesRange.value.start.toString(),
          max: valuesRange.value.end.toString(),
          search: search,
        );
        if (searchFiltersResult.isLeft) {
          Get.snackbar('Login', 'user not found');
        } else if (searchFiltersResult.isRight) {
          filteredFlowerList.clear();
          filteredFlowerList.addAll(searchFiltersResult.right);
          hideLoading();
        }
      } else if (selectedItemDropDown.value != 'select a item') {
        final searchFiltersResult =
            await _repository.searchTextFieldCategoryPrice(
          category: selectedItemDropDown.value,
          min: valuesRange.value.start.toString(),
          max: valuesRange.value.end.toString(),
          search: search,
        );
        if (searchFiltersResult.isLeft) {
          Get.snackbar('Login', 'user not found');
        } else if (searchFiltersResult.isRight) {
          filteredFlowerList.clear();
          filteredFlowerList.addAll(searchFiltersResult.right);
          hideLoading();
        }
      } else if (colorFilters != '') {
        final searchFiltersResult = await _repository.searchTextFieldColorPrice(
          colors: colorFilters,
          min: valuesRange.value.start.toString(),
          max: valuesRange.value.end.toString(),
          search: search,
        );
        if (searchFiltersResult.isLeft) {
          Get.snackbar('Login', 'user not found');
        } else if (searchFiltersResult.isRight) {
          filteredFlowerList.clear();
          filteredFlowerList.addAll(searchFiltersResult.right);
          hideLoading();
        }
      } else {
        if (search != '') {
          final result = await _repository.textFieldSearchWithPriceRange(
              min: valuesRange.value.start.toString(),
              max: valuesRange.value.end.toString(),
              search: search);
          if (result.isLeft) {
            Get.snackbar('Login', 'user not found');
          } else if (result.isRight) {
            filteredFlowerList.clear();
            filteredFlowerList.addAll(result.right);
          }
        } else {
          filteredFlowerList.clear();
        }
      }
      hideLoading();
    });
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
}
