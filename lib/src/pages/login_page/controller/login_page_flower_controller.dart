import 'package:either_dart/either.dart';
import 'package:flower_app/flower_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repositories/login_page_flower_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPageFlowerController extends GetxController {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final TextEditingController passWordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final LoginPageFlowerRepository _repository = LoginPageFlowerRepository();
  RxBool obscureText = true.obs;
  RxBool rememberMe = false.obs;
  RxBool clearRememberMe = false.obs;
  late int usertype;

  String vendorUserEmail = '';

  void toggleClearRememberMe(bool value) {
    clearRememberMe.value = value;
  }

  void toggleRememberMe(bool value) {
    rememberMe.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    isLoggedIn().then((loggedIn) {
      if (loggedIn) {
        userType().then((userType) {
          if (userType == 1) {
            Get.offAndToNamed(
                RouteNames.loginPageFlower + RouteNames.vendorHomePageFlower);
          } else if (userType == 2) {
            Get.offAndToNamed(
                RouteNames.loginPageFlower + RouteNames.customerHomePageFlower);
          }
        });
      }
    });
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

  void saveLoginStatus(bool isLoggedIn, int userType, String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
    await prefs.setInt('userType', userType);
    await prefs.setString('userEmail', userEmail);
  }

  Future<String> userEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userEmail') ?? emailController.text;
  }

  void clearLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<int> userType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getInt('userType') ?? 1;
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> onSubmitLogin() async {
    if (!loginFormKey.currentState!.validate()) {
      Get.snackbar('login', 'Your must be enter required field');
      return;
    }
    final Either<String, String> resultOrExceptionUserValidate2 =
        await _repository.checkUserValidate(
            passWord: passWordController.text,
            email: emailController.text,
            user: 2);
    resultOrExceptionUserValidate2.fold((left) {
      saveLoginStatus(rememberMe.value, 2, emailController.text);
      usertype = 2;
      Get.offAndToNamed(
          RouteNames.loginPageFlower + RouteNames.customerHomePageFlower);
      loginFormKey.currentState?.reset();
      return;
    }, (right) => Get.snackbar('Login', 'user2 not found'));

    final Either<String, String> resultOrExceptionVendorValidate1 =
        await _repository.checkVendorValidate(
            passWord: passWordController.text,
            email: emailController.text,
            user: 1);
    resultOrExceptionVendorValidate1.fold((left) {
      saveLoginStatus(rememberMe.value, 1, emailController.text);
      usertype = 1;
      Get.offAndToNamed(RouteNames.loginPageFlower + RouteNames.vendorHomePageFlower);
      loginFormKey.currentState?.reset();
      return;
    }, (right) => Get.snackbar('Login', 'user not found'));
    return;
  }

  void goToRegisterPage() {
    Get.toNamed(RouteNames.loginPageFlower + RouteNames.registerPageFlower);
  }
}
