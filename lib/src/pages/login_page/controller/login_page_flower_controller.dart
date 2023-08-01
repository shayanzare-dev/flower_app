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
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  RxBool obscureText = true.obs;
  RxBool rememberMe = false.obs;

  @override
  void dispose() {
    passWordController.text;
    emailController.text;
    super.dispose();
  }

  RxBool isLoadingLoginBtn = false.obs;

  void showLoading() {
    isLoadingLoginBtn.value = true;
  }

  void hideLoading() {
    isLoadingLoginBtn.value = false;
  }

  void toggleRememberMe({required bool rememberValue}) {
    rememberMe.value = rememberValue;
  }

  void saveLoginStatus(
      {required bool isLoggedIn,
      required int userType,
      required String userEmail}) async {
    await _prefs.setString('userEmail', userEmail);
    await _prefs.setBool('isLoggedIn', isLoggedIn);
    await _prefs.setInt('userType', userType);
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
    final Either<String, String> resultOrExceptionUserValidate =
        await _repository.checkUserValidate(
            passWord: passWordController.text,
            email: emailController.text,
            user: 2);
    resultOrExceptionUserValidate.fold((left) async {
      final Either<String, String> resultOrExceptionVendorValidate =
          await _repository.checkVendorValidate(
              passWord: passWordController.text,
              email: emailController.text,
              user: 1);
      resultOrExceptionVendorValidate.fold((left) {
        Get.snackbar('login', 'Your email or password is incorrect');
        hideLoading();
      }, (right) {
        saveLoginStatus(
            isLoggedIn: rememberMe.value,
            userType: 1,
            userEmail: emailController.text);
        Get.offAndToNamed(RouteNames.vendorHomePageFlower);
        hideLoading();
        loginFormKey.currentState?.reset();
        return;
      });
    }, (right) async {
      saveLoginStatus(
          isLoggedIn: rememberMe.value,
          userType: 2,
          userEmail: emailController.text);
      Get.offAndToNamed(RouteNames.customerHomePageFlower);
      loginFormKey.currentState?.reset();
      hideLoading();
      return;
    });
  }

  String? validateEmail({required String value}) {
    RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    bool isValid = emailRegex.hasMatch(value);
    if (value.isEmpty || value.length < 5 || !isValid) {
      return "email must be valid";
    }
    return null;
  }

  String? validatePassword({required String value}) {
    if (value.isEmpty || value.length < 6) {
      return "Password must be of 6 characters";
    }
    return null;
  }

  Future<void> goToRegisterPage() async {
    final result = await Get.toNamed(RouteNames.registerPageFlower);
    if (result != null) {
      emailController.text = result['email'];
      passWordController.text = result['password'];
    }
  }
}
