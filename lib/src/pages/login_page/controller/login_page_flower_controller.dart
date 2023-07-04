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

  void toggleRememberMe(bool value) {
    rememberMe.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    isLoggedIn().then((loggedIn) {
      if (loggedIn) {
        Get.offAndToNamed(
            RouteNames.loginPageFlower + RouteNames.vendorHomePageFlower);
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

  void saveLoginStatus(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
    await prefs.clear();
  }

  Future<bool> isLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> onSubmitLogin() async {
    if (!loginFormKey.currentState!.validate()) {
      Get.snackbar('Register', 'Your must be enter required field');

      return;
    }
    final Either<String, bool> resultOrExceptionEmail =
        await _repository.checkEmailUser(emailController.text);
    resultOrExceptionEmail.fold((String error) async {
      final Either<String, bool> resultOrExceptionPassWord =
          await _repository.checkPassWordUser(passWordController.text);
      resultOrExceptionPassWord.fold((left) async {
        final Either<String, bool> resultOrExceptionUserType =
            await _repository.checkUserType(
                passWord: passWordController.text,
                email: emailController.text,
                user: 1);
        resultOrExceptionUserType.fold((left) {
          saveLoginStatus(rememberMe.value);
          Get.offAndToNamed(
              RouteNames.loginPageFlower + RouteNames.vendorHomePageFlower);
          return;
        }, (right) => Get.snackbar('Login', 'user1 not found'));
        final Either<String, bool> resultOrExceptionUserType1 =
            await _repository.checkUserType(
                passWord: passWordController.text,
                email: emailController.text,
                user: 2);
        resultOrExceptionUserType1.fold((left) {
          saveLoginStatus(rememberMe.value);
          Get.offAndToNamed(
              RouteNames.loginPageFlower + RouteNames.customerHomePageFlower);
          return;
        }, (right) => Get.snackbar('Login', 'user2 not found'));

        return;
      }, (right) => Get.snackbar('Login', 'passWord is not  found'));
      return;
    }, (right) async {
      if (right) {
        Get.snackbar('Login', 'Email is not  found');
      }
      return;
    });
  }

  void goToRegisterPage() {
    Get.toNamed(RouteNames.loginPageFlower + RouteNames.registerPageFlower);
  }
}
