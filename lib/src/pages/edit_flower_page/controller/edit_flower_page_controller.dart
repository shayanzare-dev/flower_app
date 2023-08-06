import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:either_dart/either.dart';
import 'package:flower_app/flower_app.dart';
import 'package:flower_app/src/pages/edit_flower_page/models/edit_color_dto.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../vendor_home_page/models/edit_flower_dto.dart';
import '../../vendor_home_page/models/flower_list_view_model.dart';
import '../../vendor_home_page/models/vendor_view_model.dart';
import '../models/add_category_dto.dart';
import '../models/category_list_view_model.dart';
import '../models/edit_category_dto.dart';
import '../repositories/edit_flower_repository.dart';

class EditFlowerPageController extends GetxController {
  final GlobalKey<FormState> editFlowerFormKey = GlobalKey<FormState>();
  final TextEditingController flowerNameController = TextEditingController();
  final TextEditingController flowerDescriptionController =
      TextEditingController();
  final TextEditingController flowerPriceController = TextEditingController();
  final TextEditingController flowerCountController = TextEditingController();
  FlowerListViewModel editFlowerItem = Get.arguments;
  final EditFlowerRepository _repository = EditFlowerRepository();
  Rx<Color> selectedColor = const Color(0xff54786c).obs;
  Color selectedColors = const Color(0xff54786c);
  File? imageFile;
  Rx<String> imageAddressToString = "".obs;
  RxList<dynamic> categoryChips = <dynamic>[].obs;
  final TextEditingController categoryTextController = TextEditingController();
  RxBool isLoadingEditFlowerBtn = false.obs;
  RxList<String> suggestions = <String>[].obs;
  List<String> getFilteredSuggestions = [];
  RxList<String> categoryChipsAdd = RxList();
  RxList<CategoryListViewModel> categoryList = RxList();

  @override
  void onInit() {
    super.onInit();
    getCategoryList();
    flowerNameController.text = editFlowerItem.name;
    flowerDescriptionController.text = editFlowerItem.shortDescription;
    flowerPriceController.text = editFlowerItem.price.toString();
    flowerCountController.text = editFlowerItem.countInStock.toString();
    selectedColors = Color(editFlowerItem.color);
    selectedColor = selectedColors.obs;
    categoryChips = editFlowerItem.category.obs;
    imageAddressToString.value = editFlowerItem.image;
    if (imageAddressToString.value.isNotEmpty) {
      imageToShow = Rx<Uint8List>(base64Decode(imageAddressToString.value));
    }
    flowerPriceController.addListener(_onPriceChanged);
  }

  @override
  void dispose() {
    categoryTextController.dispose();
    super.dispose();
  }

  void changeColor(Color color) {
    selectedColor.value = color;
    selectedColors = color;
  }

  final RxInt integerPart = 0.obs;
  final RegExp _priceRegex = RegExp(r'^(\d{1,3}(,\d{3})*)$');

  void _onPriceChanged() {
    final match = _priceRegex.firstMatch(flowerPriceController.text);
    if (match != null) {
      final integerPartString = match.group(1)?.replaceAll(',', '') ?? '0';
      integerPart.value = int.parse(integerPartString);
    }
  }

  void updateSuggestions(String text) {
    if (text == '') {
      suggestions.clear();
    } else {
      List<String> filteredList = getFilteredSuggestions
          .where((suggestion) => suggestion.startsWith(text))
          .toList();
      suggestions.value = filteredList;
    }
  }

  void addChip() {
    final text = categoryTextController.text.trim();
    if (text.isNotEmpty && !categoryChips.contains(text)) {
      categoryChips.add(text);
      categoryChipsAdd.add(text);
      suggestions.clear();
      categoryTextController.clear();
      if (categoryList.isEmpty) {
        addCategoryList();
      } else {
        if (text.isNotEmpty && !categoryList.first.category.contains(text)) {
          categoryList.first.category.add(text);
        }
        editCategoryList();
      }
    }
  }

  Future<void> addCategoryList() async {
    AddCategoryDto dto = AddCategoryDto(category: categoryChipsAdd);
    final result = await _repository.addCategory(dto);
    if (result.isLeft) {
      Get.snackbar('', 'user not found');
    } else if (result.isRight) {
      getCategoryList();
    }
  }

  Future<void> editCategoryList() async {
    EditCategoryDto dto = EditCategoryDto(
        category: categoryList.first.category, id: categoryList.first.id);
    final result =
        await _repository.editCategoryList(dto, categoryList.first.id);
    if (result.isLeft) {
      Get.snackbar('', 'user not found');
    } else if (result.isRight) {
      getCategoryList();
    }
  }

  Future<void> getCategoryList() async {
    getFilteredSuggestions.clear();
    final result = await _repository.getCategoryList();
    if (result.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (result.isRight) {
      categoryList.addAll(result.right);
      for (final item in result.right) {
        for (final categoryItem in item.category) {
          getFilteredSuggestions.add(categoryItem);
        }
      }
    }
  }

  void removeChip({required int index}) => categoryChips.removeAt(index);

  void defaultImage() {
    imageAddressToString.value = "";
    imageToShow = Rx<Uint8List>(base64Decode(''));
  }

  Rx<Uint8List> imageToShow = Rx<Uint8List>(base64Decode(''));

  Future<void> getImage({required ImageSource imageSource}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        List<int> imageBytes = await pickedFile.readAsBytes();
        imageToShow.value = await pickedFile.readAsBytes();
        imageAddressToString.value = base64Encode(imageBytes);
        update();
      }
    } else {
      Get.snackbar('Image', 'No image selected.');
    }
  }

  Future<void> editFlowerButton() async {
    isLoadingEditFlowerBtn.value = true;
    final EditFlowerDto dto = _generateEditFlowerDto();
    final Either<String, FlowerListViewModel> resultOrException =
        (await _repository.editFlower(dto, editFlowerItem.id));
    resultOrException.fold((String error) {
      isLoadingEditFlowerBtn.value = false;
      return Get.snackbar('Register',
          'Your registration is not successfully code error:$error');
    }, (FlowerListViewModel addRecord) {
      editColorList(colorId: editFlowerItem.id, color: selectedColors.value);
      Get.offAndToNamed(RouteNames.vendorHomePageFlower);
      isLoadingEditFlowerBtn.value = false;
    });
    return;
  }

  EditFlowerDto _generateEditFlowerDto() {
    String inputPriceFlower = flowerPriceController.text;
    int priceFlower = int.parse(inputPriceFlower.replaceAll(',', ''));
    return EditFlowerDto(
        id: editFlowerItem.id,
        price: priceFlower,
        shortDescription: flowerDescriptionController.text,
        countInStock: int.parse(flowerCountController.text),
        category: categoryChips,
        name: flowerNameController.text,
        color: selectedColors.value,
        image: imageAddressToString.value,
        vendorUser: VendorViewModel(
            id: editFlowerItem.vendorUser.id,
            passWord: editFlowerItem.vendorUser.passWord,
            firstName: editFlowerItem.vendorUser.firstName,
            lastName: editFlowerItem.vendorUser.lastName,
            email: editFlowerItem.vendorUser.email,
            image: editFlowerItem.vendorUser.image,
            userType: editFlowerItem.vendorUser.userType));
  }

  Future<void> editColorList({required int colorId, required int color}) async {
    EditColorDto dto = EditColorDto(id: colorId, color: color);
    final result = await _repository.editColorList(dto, colorId);
    if (result.isLeft) {
      Get.snackbar('', 'user not found');
    } else if (result.isRight) {}
  }

  String? validateFlowerName({required String value}) {
    if (value.isEmpty || value.length < 2 || value.length > 15) {
      return "flower name must be between 2 and 15 characters";
    }
    return null;
  }

  String? validateFlowerDescription({required String value}) {
    if (value.isEmpty || value.length < 10 || value.length > 25) {
      return "flower description must be between 10 and 25 characters";
    }
    return null;
  }

  String? validateFlowerPrice({required String value}) {
    final RegExp integerRegex = RegExp(r'^\d{1,3}(,\d{3})*$');
    bool isValid = integerRegex.hasMatch(value);
    if (value.isEmpty || value.length > 8 || !isValid) {
      return "flower price must be valid number";
    }
    return null;
  }

  String? validateFlowerCount({required String value}) {
    RegExp integerRegex = RegExp(r'^\d+$');
    bool isValid = integerRegex.hasMatch(value);
    if (value.isEmpty || value.length > 3 || !isValid) {
      return "flower count must be valid number ";
    }
    return null;
  }
}
