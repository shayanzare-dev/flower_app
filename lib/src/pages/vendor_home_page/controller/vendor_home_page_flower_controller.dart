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
  RxMap<int, RxBool> isLoadingDeleteButton = RxMap<int, RxBool>();
  RxBool isLoadingFlowerList = false.obs;
  RxBool isButtonEnabled = true.obs;
  RxString formatPrice = ''.obs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

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
    final EditFlowerDto dto = _generateEditFlowerPlusDto(flowerItem: flowerItem);
    final Either<String, FlowerListViewModel> resultOrException =
        (await _repository.editFlower(dto, flowerItem.id));
    resultOrException.fold(
        (String error) {
          isLoadingCountPlus[flowerItem.id] = false.obs;
          return Get.snackbar('Register',
            'Your registration is not successfully code error:$error');
        },
        (FlowerListViewModel addRecord) {
          flowerList[index] =
              flowerItem.copyWith(countInStock: flowerList[index].countInStock + 1);
      isLoadingCountPlus[flowerItem.id] = false.obs;
    });
    return;
  }

  EditFlowerDto _generateEditFlowerPlusDto({required FlowerListViewModel flowerItem}) {
    return EditFlowerDto(
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
  }

  Future<void> editCountFlowerMinus(
      {required FlowerListViewModel flowerItem}) async {
    isLoadingCountMinus[flowerItem.id] = true.obs;
    if (flowerItem.countInStock > 0) {
      final int index = flowerList.indexOf(flowerItem);
      final EditFlowerDto dto = _generateEditFlowerMinusDto(flowerItem: flowerItem);
      final Either<String, FlowerListViewModel> resultOrException =
          (await _repository.editFlower(dto, flowerItem.id));
      resultOrException.fold(
          (String error) {
            isLoadingCountMinus[flowerItem.id] = false.obs;
            return Get.snackbar('Register',
              'Your registration is not successfully code error:$error');
          },
          (FlowerListViewModel addRecord) {
            flowerList[index] =
                flowerItem.copyWith(countInStock: flowerList[index].countInStock - 1);
        isLoadingCountMinus[flowerItem.id] = false.obs;
      });
    } else {
      Get.snackbar('edit Flower', 'can not minus count in stock');
    }
    return;
  }

  EditFlowerDto _generateEditFlowerMinusDto({required FlowerListViewModel flowerItem}) {
    return EditFlowerDto(
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
  }


  Future<void> deleteFlowerItem(
      {required FlowerListViewModel flowerItem}) async {
    isLoadingDeleteButton[flowerItem.id] = true.obs;
    flowerList.refresh();
    final result = await _repository.deleteFlowerItem(flowerItem.id);
    if (result.right == 'success') {
      deleteColorFlowerItem(flowerItem: flowerItem);
    } else {
      isLoadingDeleteButton[flowerItem.id] = false.obs;
      Get.snackbar('error', result.left);
    }
  }

  Future<void> deleteColorFlowerItem(
      {required FlowerListViewModel flowerItem}) async {
    final result =
        await _repository.deleteColorListItem(colorId: flowerItem.id);
    if (result.right == 'success') {
      final int index = flowerList.indexOf(flowerItem);
      flowerList.removeAt(index);
      isLoadingDeleteButton[flowerItem.id] = false.obs;
    } else {
      isLoadingDeleteButton[flowerItem.id] = false.obs;
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
      Get.snackbar('get user', 'user not found');
    } else if (result.isRight) {
      vendorUser.addAll(result.right);
    }
  }



  Future<void> getFlowerList() async {
    isLoadingFlowerList.value = true;
    isButtonEnabled.value = false;
    flowerList.clear();
    final result = await _repository.getFlowerList(vendorUserEmail);
    if (result.isLeft) {
      isLoadingFlowerList.value = false;
      isButtonEnabled.value = true;
      Get.snackbar('get Flower', 'flower is not found');
    } else if (result.isRight) {
      flowerList.addAll(result.right);
      for (final item in result.right) {
        isLoadingCountMinus[item.id] = false.obs;
        isLoadingCountPlus[item.id] = false.obs;
        isLoadingDeleteButton[item.id] = false.obs;
      }
      isLoadingFlowerList.value = false;
      isButtonEnabled.value = true;
    }
  }


  void goToEditFlowerPage({required FlowerListViewModel flowerItem}) {
    Get.offAndToNamed(
        RouteNames.vendorHomePageFlower + RouteNames.editFlowerPage,
        arguments: flowerItem  );
  }

  void clearLoginStatus() async {
    await _prefs.clear();
  }

  void goToLoginPage() {
    Get.offAllNamed(RouteNames.loadingPageFlower);
  }
}
