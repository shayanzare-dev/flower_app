import 'package:either_dart/either.dart';
import 'package:flower_app/flower_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repositories/login_page_flower_repository.dart';

class LoginPageFlowerController extends GetxController {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final TextEditingController passWordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final LoginPageFlowerRepository _repository = LoginPageFlowerRepository();
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
      resultOrExceptionPassWord.fold((left) {
        Get.offAndToNamed(
            RouteNames.loginPageFlower + RouteNames.homePageFlower);
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
