import 'dart:convert';
import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../flower_app.dart';
import '../../vendor_home_page/models/vendor_view_model.dart';
import '../models/add_category_dto.dart';
import '../models/add_color_dto.dart';
import '../models/add_flower_dto.dart';
import '../models/category_list_view_model.dart';
import '../models/edit_category_dto.dart';
import '../models/flower_list_view_model.dart';
import '../repositories/vendor_add_flower_page_repository.dart';

class VendorAddFlowerPageController extends GetxController {
  SharedPreferences _prefs = Get.find<SharedPreferences>();
  final VendorAddFlowerPageRepository _repository =
  VendorAddFlowerPageRepository();
  final GlobalKey<FormState> addFlowerFormKey = GlobalKey<FormState>();
  final TextEditingController flowerNameController = TextEditingController();
  final TextEditingController flowerDescriptionController =
  TextEditingController();
  final TextEditingController flowerPriceController = TextEditingController();
  final TextEditingController flowerCountController = TextEditingController();
  final TextEditingController categoryTextController = TextEditingController();
  RxList<VendorViewModel> vendorUser = RxList();
  final RxList<String> categoryChips = <String>[].obs;
  RxList<FlowerListViewModel> flowerList = RxList();
  File? imageFile;
  Rx<String> imageAddressToString = "".obs;
  Rx<String> imageAddressToShow = "".obs;

  final Rx<Color> selectedColor = const Color(0xff04927c).obs;
  Color selectedColors = const Color(0xff04927c);
  String vendorUserEmail = '';

  RxBool isLoadingAddFlowerBtn = false.obs;
  void showLoading() {
    isLoadingAddFlowerBtn.value = true;
  }
  void hideLoading() {
    isLoadingAddFlowerBtn.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    _prefs = Get.find<SharedPreferences>();
    vendorUserEmail = _prefs.getString('userEmail') ?? 'test@gmail.com';
    getProfileUser();
    flowerPriceController.addListener(_onPriceChanged);
    getCategoryList();
  }


  Future<void> getProfileUser() async {
    final result = await _repository.getVendorUser(vendorUserEmail);
    if (result.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (result.isRight) {
      vendorUser.addAll(result.right);
    }
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


  RxList<String> suggestions = <String>[].obs;

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

  List<String> getFilteredSuggestions = [];

  void addChip() {
    final text = categoryTextController.text.trim();
    if (text.isNotEmpty && !categoryChips.contains(text)) {
      categoryChips.add(text);
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

  RxList<CategoryListViewModel> categoryList = RxList();

  Future<void> addCategoryList() async {
    AddCategoryDto dto = AddCategoryDto(category: categoryChips);
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
    imageAddressToShow.value = "";
  }

  Future<void> getImage({required ImageSource imageSource}) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        List<int> imageBytes = await pickedFile.readAsBytes();
        imageAddressToShow.value = pickedFile.path.toString();
        imageAddressToString.value = base64Encode(imageBytes);
        update();
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
    String inputPriceFlower = flowerPriceController.text;
    int priceFlower = int.parse(inputPriceFlower.replaceAll(',', ''));
    final AddFlowerDto dto = AddFlowerDto(
        price: priceFlower,
        shortDescription: flowerDescriptionController.text,
        countInStock: int.parse(flowerCountController.text),
        category: categoryChips,
        name: flowerNameController.text,
        color: selectedColors.value,
        image: imageAddressToString.value,
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

      addColorList(color: selectedColors.value);
      categoryChips.clear();
      addFlowerFormKey.currentState?.reset();
      defaultImage();
      Get.offAndToNamed(RouteNames.vendorHomePageFlower);
      hideLoading();

    });
    return;
  }

  Future<void> addColorList({required int color}) async {
    AddColorDto dto = AddColorDto(color: color );
    final result = await _repository.addColorList(dto);
    if (result.isLeft) {
      Get.snackbar('add color List', 'not successfully');
    } else if (result.isRight) {
    }
  }

  String? validateFlowerName({required String value}) {
    if (value.isEmpty || value.length < 2 || value.length > 15) {
      return "flower name must be between 2 and 15 characters";
    }
    return null;
  }

  String? validateFlowerDescription({required String value}) {
    if (value.isEmpty || value.length < 10  || value.length >25) {
      return "flower description must be between 10 and 25 characters";
    }
    return null;
  }

  String? validateFlowerPrice({required String value}) {
    final RegExp integerRegex = RegExp(r'^\d{1,3}(,\d{3})*$');
    bool isValid = integerRegex.hasMatch(value);
    if (value.isEmpty ||  value.length > 8 || !isValid) {
      return "flower price must be valid number";
    }
    return null;
  }

  String? validateFlowerCount({required String value}) {
    RegExp integerRegex = RegExp(r'^\d+$');
    bool isValid = integerRegex.hasMatch(value);
    if (value.isEmpty  ||  value.length > 3 || !isValid) {
      return "flower count must be valid number ";
    }
    return null;
  }

  void clearLoginStatus() async {
    await _prefs.clear();
  }

}
