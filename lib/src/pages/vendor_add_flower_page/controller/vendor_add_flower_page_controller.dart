import 'dart:convert';
import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../flower_app.dart';
import '../../vendor_home_page/models/vendor_view_model.dart';
import '../models/add_flower_dto.dart';
import '../models/flower_list_view_model.dart';
import '../repositories/vendor_add_flower_page_repository.dart';

class VendorAddFlowerPageController extends GetxController {
  final SharedPreferences _prefs = Get.find<SharedPreferences>();
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
  File? imageFile;
  String base64Image = "";
  final Rx<Color> selectedColor = const Color(0xff04927c).obs;
  Color selectedColors = const Color(0xff04927c);
  String vendorUserEmail = '';


  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(seconds: 2), () {
      getProfileUser();
    });
    Future.delayed(const Duration(seconds: 1), () {
      userEmail().then((userEmail) {
        vendorUserEmail = userEmail;
      });
    });
  }

  Future<void> getProfileUser() async {
    final result = await _repository.getVendorUser(vendorUserEmail);
    if (result.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (result.isRight) {
      vendorUser.addAll(result.right);
    }
  }

  Future<String> userEmail() async {
    return _prefs.getString('userEmail') ?? 'test@gmail.com';
  }



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
    resultOrException.fold(
        (String error) => Get.snackbar('Register',
            'Your registration is not successfully code error:$error'),
        (FlowerListViewModel addRecord) async {
      Get.snackbar('Add Flower', 'Your Add Flower is successfully');
      refresh();
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

  void goToHomeVendorPage() {
    Get.offAndToNamed(RouteNames.loginPageFlower+RouteNames.vendorHomePageFlower);
  }
}
