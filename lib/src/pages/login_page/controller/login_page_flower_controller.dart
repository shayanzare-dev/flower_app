import 'package:flower_app/flower_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPageFlowerController extends GetxController {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final TextEditingController passWordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  RxBool obscureText = true.obs;

  @override
  void onInit() {
    super.onInit();
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

  void checkLogin() {
    final isValid = loginFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    loginFormKey.currentState!.save();
    // Get.offAndToNamed(RouteName.myBankHomePage); TODO: go to home page
  }

  void goToRegisterPage() {
    Get.toNamed(RouteNames.loginPageFlower + RouteNames.registerPageFlower);
  }
}
