import 'dart:convert';
import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:flower_app/flower_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../vendor_home_page/models/edit_flower_dto.dart';
import '../../vendor_home_page/models/flower_list_view_model.dart';
import '../../vendor_home_page/models/vendor_view_model.dart';
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

  @override
  void onInit() {
    super.onInit();
    flowerNameController.text = editFlowerItem.name;
    flowerDescriptionController.text = editFlowerItem.shortDescription;
    flowerPriceController.text = editFlowerItem.price.toString();
    flowerCountController.text = editFlowerItem.countInStock.toString();
    selectedColors = Color(editFlowerItem.color);
    selectedColor = selectedColors.obs;
    categoryChips = editFlowerItem.category.obs;
    base64Image = editFlowerItem.image;
  }

  @override
  void dispose() {
    categoryTextController.dispose();

    super.dispose();
  }

  Rx<Color> selectedColor = const Color(0xff54786c).obs;
  Color selectedColors =  Color(0xff54786c);

  void changeColor(Color color) {
    selectedColor.value = color;
    selectedColors = color;
  }

   RxList<dynamic> categoryChips = <dynamic>[].obs;
  final TextEditingController categoryTextController = TextEditingController();

  void addChip() {
    final text = categoryTextController.text.trim();
    if (text.isNotEmpty && !categoryChips.contains(text)) {
      categoryChips.add(text);
      categoryTextController.clear();
    }
  }

  void removeChip(int index) => categoryChips.removeAt(index);

  File? imageFile;
  String base64Image = "";

  Future<void> getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
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

  Future<void> editFlower() async {
    final EditFlowerDto dto = EditFlowerDto(
        id: editFlowerItem.id,
        price: int.parse(flowerPriceController.text) ,
        shortDescription: flowerDescriptionController.text,
        countInStock: int.parse(flowerCountController.text),
        category: categoryChips,
        name: flowerNameController.text,
        color: selectedColors.value,
        image: base64Image,
        vendorUser: vendorViewModel(
            id: editFlowerItem.vendorUser.id,
            passWord: editFlowerItem.vendorUser.passWord,
            firstName:editFlowerItem.vendorUser.firstName,
            lastName:editFlowerItem.vendorUser.lastName,
            email: editFlowerItem.vendorUser.email,
            image: editFlowerItem.vendorUser.image,
            userType: editFlowerItem.vendorUser.userType));

    final Either<String, FlowerListViewModel> resultOrException =
    (await _repository.editFlower(dto, editFlowerItem.id));
    resultOrException.fold(
            (String error) => Get.snackbar('Register',
            'Your registration is not successfully code error:$error'),
            (FlowerListViewModel addRecord) {

          Get.offAndToNamed(RouteNames.loginPageFlower+RouteNames.vendorHomePageFlower);
          Get.snackbar('edit Flower', 'Your Add Flower is successfully');

        });
    return;
  }


  String? validateFlowerName(String value) {
    if (value.isEmpty || value.length < 2) {
      return "flower name must be of 2 characters";
    }
    return null;
  }

  String? validateFlowerDescription(String value) {
    if (value.isEmpty || value.length < 10) {
      return "flower description must be of 10 characters";
    }
    return null;
  }

  String? validateFlowerPrice(String value) {
    if (value.isEmpty || value.length < 2) {
      return "flower price must be of 2 characters";
    }
    return null;
  }

  String? validateFlowerCount(String value) {
    if (value.isEmpty) {
      return "flower count is required ";
    }
    return null;
  }
}
