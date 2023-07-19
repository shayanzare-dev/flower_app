import 'package:either_dart/either.dart';
import 'package:flower_app/flower_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repositories/login_page_flower_repository.dart';

class LoginPageFlowerController extends GetxController {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final TextEditingController passWordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final LoginPageFlowerRepository _repository = LoginPageFlowerRepository();
  final SharedPreferences _prefs = Get.find<SharedPreferences>();
  RxBool obscureText = true.obs;
  RxBool rememberMe = false.obs;

  @override
  void onInit() {
    refresh();
    super.onInit();
  }

  var isLoading = false.obs;

  void showLoading() {
    isLoading.value = true;
  }

  void hideLoading() {
    isLoading.value = false;
  }

  void toggleRememberMe(bool value) {
    rememberMe.value = value;
  }

  void saveLoginStatus(bool isLoggedIn, int userType, String userEmail) async {
    await _prefs.setBool('isLoggedIn', isLoggedIn);
    await _prefs.setInt('userType', userType);
    await _prefs.setString('userEmail', userEmail);
  }

  void clearLoginStatus() async {
    await _prefs.clear();
  }

  Future<void> onSubmitLogin() async {
    if (!loginFormKey.currentState!.validate()) {
      Get.snackbar('login', 'Your must be enter required field');
      return;
    }
    showLoading();
    final Either<String, String> resultOrExceptionUserValidate2 =
        await _repository.checkUserValidate(
            passWord: passWordController.text,
            email: emailController.text,
            user: 2);
    resultOrExceptionUserValidate2.fold((left) {
      saveLoginStatus(rememberMe.value, 2, emailController.text);
      Get.offAndToNamed(RouteNames.loadingPageFlower +
          RouteNames.loginPageFlower +
          RouteNames.customerHomePageFlower);
      loginFormKey.currentState?.reset();
      hideLoading();
      return;
    }, (right) {});
    final Either<String, String> resultOrExceptionVendorValidate1 =
        await _repository.checkVendorValidate(
            passWord: passWordController.text,
            email: emailController.text,
            user: 1);
    resultOrExceptionVendorValidate1.fold((left) {
      saveLoginStatus(rememberMe.value, 1, emailController.text);
      Get.offAndToNamed(RouteNames.loadingPageFlower +
          RouteNames.loginPageFlower +
          RouteNames.vendorHomePageFlower);
      hideLoading();
      loginFormKey.currentState?.reset();
      return;
    }, (right) {
      hideLoading();
    });
    return;
  }

  String? validateEmail(String value) {
    RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    bool isValid = emailRegex.hasMatch(value);
    if (value.isEmpty || value.length < 5 || !isValid) {
      return "email must be valid";
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty || value.length < 6) {
      return "Password must be of 6 characters";
    }
    return null;
  }

  void goToRegisterPage() {
    Get.toNamed(RouteNames.loadingPageFlower +
        RouteNames.loginPageFlower +
        RouteNames.registerPageFlower);
  }
}
