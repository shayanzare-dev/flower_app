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
import '../models/add_flower_dto.dart';
import '../models/edit_flower_dto.dart';
import '../models/edit_vendor_dto.dart';
import '../models/flower_list_view_model.dart';
import '../models/vendor_view_model.dart';
import '../repositories/vendor_home_page_flower_repository.dart';
import '../view/widget/bottom_navigation_bar_add_screen.dart';
import '../view/widget/bottom_navigation_bar_history_screen.dart';
import '../view/widget/bottom_navigation_bar_home_screen.dart';
import '../view/widget/bottom_navigation_bar_profile_screen.dart';
import '../view/widget/bottom_navigation_bar_search_screen.dart';
import '../view/widget/grid_item.dart';

class VendorHomePageFlowerController extends GetxController {
  final GlobalKey<FormState> addFlowerFormKey = GlobalKey<FormState>();
  final TextEditingController flowerNameController = TextEditingController();
  final TextEditingController flowerDescriptionController =
      TextEditingController();
  final TextEditingController flowerPriceController = TextEditingController();
  final TextEditingController flowerCountController = TextEditingController();

  final TextEditingController searchController = TextEditingController();

  RxList<FlowerListViewModel> filteredFlowerList = RxList();

  RxList<FlowerListViewModel> flowerList = RxList();

  RxList<vendorViewModel> vendorUser = RxList();

  final SharedPreferences _prefs = Get.find<SharedPreferences>();

  final VendorHomePageFlowerRepository _repository =
      VendorHomePageFlowerRepository();

  List<String> savedSelections = [];

  List<String> dropDownButtonList = [
    'select a item',
  ];
  Rx<String> selectedItemDropDown = Rx<String>('select a item');

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

  Rx<RangeValues> valuesRange = Rx<RangeValues>(RangeValues(0, 100));

  RangeValues get values => valuesRange.value;

  void setValues(RangeValues values) {
    valuesRange.value = values;
  }

  void searchFilterFlowers() {
    int? colorFilter;
    for (int i = 0; i < savedSelections.length; i++) {
      items[i].isSelected = savedSelections[i] == 'true';
      if (items[i].isSelected) {
        colorFilter = items[i].color.value;
      }
    }
    filteredFlowerList.value = flowerList.where((flower) {
      return flower.category.contains(selectedItemDropDown.toString()) ||
          flower.color == colorFilter;
    }).toList();
  }

  void searchFlowers(String query) {
    if (query != '') {
      filteredFlowerList.value = flowerList.where((flower) {
        return flower.name.toLowerCase().contains(query.toLowerCase()) ||
            flower.shortDescription.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }

  final RxList<GridItem> items = RxList<GridItem>([]);

  String vendorUserEmail = '';

  @override
  void onInit() {
    super.onInit();

    Future.delayed(const Duration(seconds: 2), () {
      getProfileUser();
      getFlowerList();
      getOrderListVendorHistory();
    });
    Future.delayed(const Duration(seconds: 3), () {
      editVendorFlowerList();
    });
    Future.delayed(const Duration(seconds: 1), () {
      userEmail().then((userEmail) {
        vendorUserEmail = userEmail;
      });
    });
  }

  RxList<BoughtFlowers> boughtFlowerList = RxList();
  RxList<CartOrder> boughtOrderList = RxList();

  Future<void> getOrderListVendorHistory() async {
    boughtOrderList.clear();
    final result = await _repository.getVendorUserOrdersHistory();
    if (result.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (result.isRight) {
      boughtOrderList.addAll(result.right);
      for (final item in result.right) {
        for (final items in item.boughtFlowers) {
          if (items.flowerListViewModel.vendorUser.email ==
              vendorUser[0].email) {
            boughtFlowerList.addAll(item.boughtFlowers);
          }
        }
      }
    }
  }

  void toggleSelection(int index) {
    items[index].isSelected = !items[index].isSelected;
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

  @override
  void dispose() {
    categoryTextController.dispose();
    searchController.dispose();

    super.dispose();
  }

  @override
  Future<void> refresh() async {
    filteredFlowerList.clear();
    selectedItemDropDown = Rx<String>('select a item');

    Future.delayed(const Duration(seconds: 2), () {
      getProfileUser();
      getFlowerList();
      getOrderListVendorHistory();
    });
    Future.delayed(const Duration(seconds: 3), () {
      editVendorFlowerList();
    });
    Future.delayed(const Duration(seconds: 1), () {
      userEmail().then((userEmail) {
        vendorUserEmail = userEmail;
      });
    });
    Get.snackbar('Refresh Flower list', 'Refresh is successfully');
  }

  Future<void> editCountFlowerPlus(FlowerListViewModel flowerItem) async {
    final EditFlowerDto dto = EditFlowerDto(
        id: flowerItem.id,
        price: flowerItem.price,
        shortDescription: flowerItem.shortDescription,
        countInStock: flowerItem.countInStock + 1,
        category: flowerItem.category,
        name: flowerItem.name,
        color: flowerItem.color,
        image: flowerItem.image,
        vendorUser: vendorViewModel(
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
      Future.delayed(const Duration(seconds: 3), () {
        editVendorFlowerList();
      });
      Get.snackbar('edit Flower', 'Your Add Flower is successfully');
    });
    return;
  }

  Future<void> editCountFlowerMinus(FlowerListViewModel flowerItem) async {
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
          vendorUser: vendorViewModel(
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
        Future.delayed(const Duration(seconds: 3), () {
          editVendorFlowerList();
        });
        Get.snackbar('edit Flower', 'Your Add Flower is successfully');
      });
    } else {
      Get.snackbar('edit Flower', 'can not minus count in stock');
    }
    return;
  }

  Future<void> deleteFlowerItem(FlowerListViewModel flowerItem) async {
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
        deleteFlowerItem(flowerItem);
        Navigator.of(context).pop();
        break;
    }
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
    selectedColors = color;
  }

  final selectedIndex = RxInt(0);

  static List<Widget> widgetOptions = <Widget>[
    HomeScreen(),
    AddScreen(),
    SearchScreen(),
    HistoryScreen(),
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

  Future<void> editVendorFlowerList() async {
    final EditVendorDto dto = EditVendorDto(
        id: vendorUser.first.id,
        passWord: vendorUser.first.passWord,
        firstName: vendorUser.first.firstName,
        lastName: vendorUser.first.lastName,
        email: vendorUser.first.email,
        image: vendorUser.first.image,
        userType: vendorUser.first.userType,
        flowerList: flowerList);
    // dto.copyWith(flowerList: flowerList);
    final Either<String, String> resultOrException =
        (await _repository.editVendorUser(dto, vendorUser.first.id));
    for (int i = 0; i < flowerList.length; i++) {}
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
        vendorUser: vendorViewModel(
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

  void goToEditFlowerPage(FlowerListViewModel flowerItem) {
    Get.toNamed(
        RouteNames.loginPageFlower +
            RouteNames.vendorHomePageFlower +
            RouteNames.editPageFlower,
        arguments: flowerItem);
  }

  void goToLoginPage() {
    Get.offAndToNamed(RouteNames.loginPageFlower);
  }
}
