import 'dart:async';
import 'package:either_dart/either.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../flower_app.dart';
import '../models/edit_flower_dto.dart';
import '../models/flower_list_view_model.dart';
import '../models/vendor_view_model.dart';
import '../repositories/vendor_home_page_flower_repository.dart';

class VendorHomePageFlowerController extends GetxController {
  SharedPreferences _prefs = Get.find<SharedPreferences>();
  final VendorHomePageFlowerRepository _repository =
      VendorHomePageFlowerRepository();
  RxList<FlowerListViewModel> flowerList = RxList();
  RxList<VendorViewModel> vendorUser = RxList();
  String vendorUserEmail = '';
  RxMap<int, RxBool> isLoadingCountMinus = RxMap<int, RxBool>();
  RxMap<int, RxBool> isLoadingCountPlus = RxMap<int, RxBool>();
  RxMap<int, RxBool> isLoadingDeleteBtn = RxMap<int, RxBool>();
  RxBool isLoadingFlowerList = false.obs;
  RxBool isButtonEnabled = true.obs;

  @override
  Future<void> onInit() async {
    _prefs = Get.find<SharedPreferences>();
    vendorUserEmail = _prefs.getString('userEmail') ?? 'test@gmail.com';
    getProfileUser();
    getFlowerList();
    super.onInit();
  }

  @override
  Future<void> refresh() async {
    _prefs = Get.find<SharedPreferences>();
    vendorUserEmail = _prefs.getString('userEmail') ?? 'test@gmail.com';
    getProfileUser();
    getFlowerList();
  }

  //Home Screen

  RxString formatPrice = ''.obs;



  String priceFormat({required String price}){
    formatPrice.value = '';
    int counter =0;
    for(int i = (price.length-1);i >=0;i--){
      counter++;
      String showPrice = price[i];
      if((counter%3) != 0  && i !=0){
        formatPrice.value = '$showPrice$formatPrice';
      }else if (i == 0){
        formatPrice.value = '$showPrice$formatPrice';
      }else{
        formatPrice.value = ',$showPrice$formatPrice';
      }
    }
    return formatPrice.trim();
  }

  Future<void> editCountFlowerPlus(
      {required FlowerListViewModel flowerItem}) async {
    isLoadingCountPlus[flowerItem.id] = true.obs;
    final int index = flowerList.indexOf(flowerItem);
    flowerList[index] =
        flowerItem.copyWith(countInStock: flowerList[index].countInStock + 1);
    final EditFlowerDto dto = EditFlowerDto(
        id: flowerItem.id,
        price: flowerItem.price,
        shortDescription: flowerItem.shortDescription,
        countInStock: flowerItem.countInStock + 1,
        category: flowerItem.category,
        name: flowerItem.name,
        color: flowerItem.color,
        image: flowerItem.image,
        vendorUser: VendorViewModel(
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
      isLoadingCountPlus[flowerItem.id] = false.obs;
    });
    return;
  }

  Future<void> editCountFlowerMinus(
      {required FlowerListViewModel flowerItem}) async {
    isLoadingCountMinus[flowerItem.id] = true.obs;
    if (flowerItem.countInStock > 0) {
      final int index = flowerList.indexOf(flowerItem);
      flowerList[index] =
          flowerItem.copyWith(countInStock: flowerList[index].countInStock - 1);
      final EditFlowerDto dto = EditFlowerDto(
          id: flowerItem.id,
          price: flowerItem.price,
          shortDescription: flowerItem.shortDescription,
          countInStock: flowerItem.countInStock - 1,
          category: flowerItem.category,
          name: flowerItem.name,
          color: flowerItem.color,
          image: flowerItem.image,
          vendorUser: VendorViewModel(
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
        isLoadingCountMinus[flowerItem.id] = false.obs;
      });
    } else {
      Get.snackbar('edit Flower', 'can not minus count in stock');
    }
    return;
  }

  Future<void> deleteFlowerItem(
      {required FlowerListViewModel flowerItem}) async {
    isLoadingDeleteBtn[flowerItem.id] = true.obs;
    flowerList.refresh();
    final result = await _repository.deleteFlowerItem(flowerItem.id);
    if (result.right == 'success') {
      deleteColorFlowerItem(flowerItem: flowerItem);
    } else {
      Get.snackbar('error', result.left);
    }
    isLoadingDeleteBtn[flowerItem.id] = false.obs;
  }

  Future<void> deleteColorFlowerItem(
      {required FlowerListViewModel flowerItem}) async {
    final result =
        await _repository.deleteColorListItem(colorId: flowerItem.id);
    if (result.right == 'success') {
      getFlowerList();
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
        deleteFlowerItem(flowerItem: flowerItem);
        Navigator.of(context).pop();
        break;
    }
  }

  Future<void> getProfileUser() async {
    vendorUser.clear();
    final result = await _repository.getVendorUser(vendorUserEmail);
    if (result.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (result.isRight) {
      vendorUser.addAll(result.right);
    }
  }

  List<int> priceList = [];
  double maxPrice = 2.0;

  Future<void> getFlowerList() async {
    isLoadingFlowerList = true.obs;
    isButtonEnabled.value = false;
    flowerList.clear();

    final result = await _repository.getFlowerList(vendorUserEmail);
    if (result.isLeft) {
      Get.snackbar('Login', 'user not found');
    } else if (result.isRight) {
      flowerList.addAll(result.right);
      for (final item in result.right) {
        isLoadingCountMinus[item.id] = false.obs;
        isLoadingCountPlus[item.id] = false.obs;
        isLoadingDeleteBtn[item.id] = false.obs;
        priceList.add(item.price);
      }
    }
    isButtonEnabled.value = true;
    isLoadingFlowerList = false.obs;
  }

  //Add Screen

  void goToEditFlowerPage({required FlowerListViewModel flowerItem}) {
    Get.offAndToNamed(
        RouteNames.vendorHomePageFlower + RouteNames.editFlowerPage,
        arguments: flowerItem);
  }

  void clearLoginStatus() async {
    await _prefs.clear();
  }

  void goToLoginPage() {
    Get.offAllNamed(RouteNames.loadingPageFlower);
  }
}
