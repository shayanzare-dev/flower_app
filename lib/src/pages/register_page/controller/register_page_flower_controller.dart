import 'dart:convert';
import 'package:either_dart/either.dart';
import 'package:flower_app/src/pages/shared/user_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../../flower_app.dart';
import '../models/register_user_dto.dart';
import '../models/register_vendor_dto.dart';
import '../repositories/register_page_flower_repository.dart';

class RegisterPageFlowerController extends GetxController {
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final TextEditingController passWordConfirmController =
      TextEditingController();
  Rx<UserType> userType = UserType.vendor.obs;
  final RegisterPageFlowerRepository _repository =
      RegisterPageFlowerRepository();
  String passCheckConfirm = '';
  String passCheck = '';
  RxInt selectedTypeUser = 1.obs;
  void selectedTypeUserValue(int value) {
    selectedTypeUser.value = value;
    if (selectedTypeUser.value == 1) {
      userType = UserType.vendor.obs;
    } else {
      userType = UserType.customer.obs;
    }
  }
  RxBool obscureText = true.obs;
  RxBool obscureTextConfirm = true.obs;
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

  Future<void> onSubmitRegister() async {
    if (!registerFormKey.currentState!.validate()) {
      Get.snackbar('Register', 'Your must be enter required field');
      return;
    }
    if (selectedTypeUser.value == 1) {
      final Either<String, bool> resultOrExceptionEmailVendor =
          await _repository.checkEmailVendor(emailController.text);
      resultOrExceptionEmailVendor.fold(
          (String error) => Get.snackbar('Register', 'Email already exists'),
          (right) async {
        if (right) {
          final Either<String, bool> resultOrExceptionEmailUser =
              await _repository.checkEmailUser(emailController.text);
          resultOrExceptionEmailUser.fold(
              (String error) =>
                  Get.snackbar('Register', 'Email already exists'),
              (right) async {
            final RegisterVendorDto dto = RegisterVendorDto(
                userType: userType.value,
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                passWord: passWordConfirmController.text,
                email: emailController.text,
                image: base64Image);
            final Either<String, String> resultOrException =
                (await _repository.addVendor(dto));
            resultOrException.fold(
                (String error) => Get.snackbar('Register',
                    'Your registration is not successfully code error:$error'),
                (String addRecord) {
              Get.snackbar('Register', 'Your registration is successfully');
              registerFormKey.currentState?.reset();
              Get.offAndToNamed(RouteNames.loginPageFlower);
            });
            return;
          });
        }
        return;
      });
    } else if (selectedTypeUser.value == 2) {
      final Either<String, bool> resultOrExceptionEmail =
          await _repository.checkEmailUser(emailController.text);
      resultOrExceptionEmail.fold(
          (String error) => Get.snackbar('Register', 'Email already exists'),
          (right) async {
        if (right) {
          final Either<String, bool> resultOrExceptionEmailVendor =
              await _repository.checkEmailVendor(emailController.text);
          resultOrExceptionEmailVendor.fold(
              (String error) =>
                  Get.snackbar('Register', 'Email already exists'),
              (right) async {
            final RegisterUserDto dto = RegisterUserDto(
                userType: userType.value,
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                passWord: passWordConfirmController.text,
                email: emailController.text,
                image: base64Image);
            final Either<String, String> resultOrException =
                (await _repository.addUser(dto));
            resultOrException.fold(
                (String error) => Get.snackbar('Register',
                    'Your registration is not successfully code error:$error'),
                (String addRecord) {
              Get.snackbar('Register', 'Your registration is successfully');
              registerFormKey.currentState?.reset();
              Get.offAndToNamed(RouteNames.loginPageFlower);
            });
            return;
          });
        }
        return;
      });
    }
  }


  String? validateFirstName(String value) {
    if (value.isEmpty || value.length < 3) {
      return "first name must be of 3 characters";
    }
    return null;
  }

  String? validateLastName(String value) {
    if (value.isEmpty || value.length < 3) {
      return "last name must be of 3 characters";
    }
    return null;
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

  String? validateConfirmPassword(String value) {
    if (passCheck != passCheckConfirm) {
      return "Passwords is not  match";
    }
    if (value.isEmpty || value.length < 6) {
      return "Password must be of 6 characters";
    }
    return null;
  }
}
