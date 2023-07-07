import 'dart:convert';
import 'dart:io';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../flower_app.dart';
import '../models/add_flower_dto.dart';
import '../models/edit_flower_dto.dart';
import '../models/flower_list_view_model.dart';
import '../models/user_view_model.dart';
import '../repositories/vendor_home_page_flower_repository.dart';
import '../view/widget/bottom_navigation_bar_add_screen.dart';
import '../view/widget/bottom_navigation_bar_home_screen.dart';
import '../view/widget/bottom_navigation_bar_profile_screen.dart';
import '../view/widget/bottom_navigation_bar_search_screen.dart';

class VendorHomePageFlowerController extends GetxController {
  final GlobalKey<FormState> addFlowerFormKey = GlobalKey<FormState>();
  final TextEditingController flowerNameController = TextEditingController();
  final TextEditingController flowerDescriptionController =
      TextEditingController();
  final TextEditingController flowerPriceController = TextEditingController();
  final TextEditingController flowerCountController = TextEditingController();

  RxList<FlowerListViewModel> flowerList = RxList();

  RxList<UserViewModel> vendorUser = RxList();

  final VendorHomePageFlowerRepository _repository =
      VendorHomePageFlowerRepository();

  String vendorUserEmail = '';

  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(seconds: 2), () {
      getVendorUser();
      getFlowerList();
    });
    Future.delayed(const Duration(seconds: 1), () {
      userEmail().then((userEmail) {
        vendorUserEmail = userEmail;
      });
    });

  }

  RxInt count = 0.obs;
  RxInt minCount = 0.obs;
  RxInt maxCount = 10.obs;

  void increment() {
    if (count.value < maxCount.value) {
      count++;
    }
  }

  void decrement() {
    if (count.value > minCount.value) {
      count--;
    }
  }

  Future<void> editCountFlowerPlus(FlowerListViewModel flowerItem) async {
    final EditFlowerDto dto = EditFlowerDto(
        id: flowerItem.id,
        price: flowerItem.price,
        shortDescription: flowerItem.shortDescription,
        countInStock:flowerItem.countInStock+1,
        category: flowerItem.category,
        name: flowerItem.name,
        color: flowerItem.color,
        image: flowerItem.image,
        customerUser: null,
        vendorUser: UserViewModel(
            id: flowerItem.vendorUser.id,
            passWord: flowerItem.vendorUser.passWord,
            firstName: flowerItem.vendorUser.firstName,
            lastName: flowerItem.vendorUser.lastName,
            email: flowerItem.vendorUser.email,
            image: flowerItem.vendorUser.image,
            userType: flowerItem.vendorUser.userType));

    final Either<String, FlowerListViewModel> resultOrException =
    (await _repository.editFlower(dto,flowerItem.id));
    resultOrException.fold(
            (String error) => Get.snackbar('Register',
            'Your registration is not successfully code error:$error'),
            (FlowerListViewModel addRecord) {
              getFlowerList();
          Get.snackbar('edit Flower', 'Your Add Flower is successfully');

        });
    return;
  }

  Future<void> editCountFlowerMinus(FlowerListViewModel flowerItem) async {
    final EditFlowerDto dto = EditFlowerDto(
        id: flowerItem.id,
        price: flowerItem.price,
        shortDescription: flowerItem.shortDescription,
        countInStock:flowerItem.countInStock-1,
        category: flowerItem.category,
        name: flowerItem.name,
        color: flowerItem.color,
        image: flowerItem.image,
        customerUser: null,
        vendorUser: UserViewModel(
            id: flowerItem.vendorUser.id,
            passWord: flowerItem.vendorUser.passWord,
            firstName: flowerItem.vendorUser.firstName,
            lastName: flowerItem.vendorUser.lastName,
            email: flowerItem.vendorUser.email,
            image: flowerItem.vendorUser.image,
            userType: flowerItem.vendorUser.userType));

    final Either<String, FlowerListViewModel> resultOrException =
    (await _repository.editFlower(dto,flowerItem.id));
    resultOrException.fold(
            (String error) => Get.snackbar('Register',
            'Your registration is not successfully code error:$error'),
            (FlowerListViewModel addRecord) {
          getFlowerList();
          Get.snackbar('edit Flower', 'Your Add Flower is successfully');

        });
    return;
  }


  Future<void> deleteFlowerItem(FlowerListViewModel record) async {
    final result = await _repository.deleteFlowerItem(record.id);

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
        deleteFlowerItem(flowerItem);
        Navigator.of(context).pop();
        break;
    }
  }

  Future<void> getFlowerList() async {
    flowerList.clear();
    final result = await _repository.getFlowerList(vendorUserEmail);
    if (result.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (result.isRight) {
      flowerList.addAll(result.right);
    }
  }

  Future<void> getVendorUser() async {
    final result = await _repository.getVendorUser(vendorUserEmail);
    if (result.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (result.isRight) {
      vendorUser.addAll(result.right);
    }
  }

  Future<String> userEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail') ?? 'test@gmail.com';
  }

  final RxList<String> categoryChips = <String>[].obs;
  final TextEditingController categoryTextController = TextEditingController();

  void addChip() {
    final text = categoryTextController.text.trim();
    if (text.isNotEmpty && !categoryChips.contains(text)) {
      categoryChips.add(text);
      categoryTextController.clear();
    }
  }

  void removeChip(int index) => categoryChips.removeAt(index);

  @override
  void dispose() {
    categoryTextController.dispose();
    super.dispose();
  }

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

  final Rx<Color> selectedColor = const Color(0xff54786c).obs;
  Color selectedColors = const Color(0xff54786c);


  void changeColor(Color color) {
    selectedColor.value = color;
    selectedColors =color;
  }

  final selectedIndex = RxInt(0);

  static List<Widget> widgetOptions = <Widget>[
    HomeScreen(),
    AddScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  void onItemTapped(int index) {
    selectedIndex.value = index;
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
        customerUser: null,
        vendorUser: UserViewModel(
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
        (FlowerListViewModel addRecord) {
      Get.snackbar('Add Flower', 'Your Add Flower is successfully');
      addFlowerFormKey.currentState?.reset();
    });

    return;
  }

  void goToLoginPage() {
    Get.offAndToNamed(RouteNames.loginPageFlower);
  }
}
