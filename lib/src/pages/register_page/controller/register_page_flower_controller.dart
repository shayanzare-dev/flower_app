import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:either_dart/either.dart';
import 'package:flower_app/src/pages/shared/user_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
  Rx<UserType> selectedUserType = UserType.vendor.obs;
  final RegisterPageFlowerRepository _repository =
      RegisterPageFlowerRepository();
  String passCheckConfirm = '';
  String passCheck = '';

  RxBool isLoadingRegisterBtn = false.obs;

  void showLoading() {
    isLoadingRegisterBtn.value = true;
  }

  void hideLoading() {
    isLoadingRegisterBtn.value = false;
  }

  void selectedTypeUserValue(UserType userType) {
    selectedUserType.value = userType;
  }

  RxBool obscureText = true.obs;
  RxBool obscureTextConfirm = true.obs;




  void defaultImage() {
    imageAddressToString.value = "";
    imageAddressToShow.value = "";
  }

  File? imageFile;
  Rx<String> imageAddressToString = "".obs;
  Rx<String> imageAddressToShow = "".obs;

  Future<void> getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      if (imageFile != null) {
        List<int> imageBytes = await pickedFile.readAsBytes();
        imageAddressToShow.value = pickedFile.path.toString();
        imageAddressToString.value = base64Encode(imageBytes);
        update();
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
    showLoading();
    if (selectedUserType.value == UserType.vendor) {
      final Either<String, bool> resultOrExceptionEmailVendor =
          await _repository.checkEmailVendor(emailController.text);
      resultOrExceptionEmailVendor.fold((String error) {
        hideLoading();
        return Get.snackbar('Register', 'Email already exists');
      }, (right) async {
        if (right) {
          final Either<String, bool> resultOrExceptionEmailUser =
              await _repository.checkEmailUser(emailController.text);
          resultOrExceptionEmailUser.fold((String error) {
            hideLoading();
            return Get.snackbar('Register', 'Email already exists');
          }, (right) async {
            final RegisterVendorDto dto = RegisterVendorDto(
                userType: selectedUserType.value,
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                passWord: passWordConfirmController.text,
                email: emailController.text,
                image: imageAddressToString.value);
            final Either<String, String> resultOrException =
                (await _repository.addVendor(dto));
            resultOrException.fold(
                (String error) {
                  hideLoading();
                  return Get.snackbar('Register',
                    'Your registration is not successfully code error:$error');
                },
                (String addRecord) {
              Get.back(result: {
                'email': emailController.text,
                'password': passWordConfirmController.text
              });
              registerFormKey.currentState?.reset();

              hideLoading();
            });
            return;
          });
        }
        return;
      });
    } else if (selectedUserType.value == UserType.customer) {
      final Either<String, bool> resultOrExceptionEmail =
          await _repository.checkEmailUser(emailController.text);
      resultOrExceptionEmail.fold((String error) {
        hideLoading();
        return Get.snackbar('Register', 'Email already exists');
      }, (right) async {
        if (right) {
          final Either<String, bool> resultOrExceptionEmailVendor =
              await _repository.checkEmailVendor(emailController.text);
          resultOrExceptionEmailVendor.fold((String error) {
            hideLoading();
            return Get.snackbar('Register', 'Email already exists');
          }, (right) async {
            final RegisterUserDto dto = RegisterUserDto(
                userType: selectedUserType.value,
                firstName: firstNameController.text,
                lastName: lastNameController.text,
                passWord: passWordConfirmController.text,
                email: emailController.text,
                image: imageAddressToString.value);
            final Either<String, String> resultOrException =
                (await _repository.addUser(dto));
            resultOrException.fold(
                (String error) => Get.snackbar('Register',
                    'Your registration is not successfully code error:$error'),
                (String addRecord) {
              Get.back(result: {
                'email': emailController.text,
                'password': passWordConfirmController.text
              });
              hideLoading();
              registerFormKey.currentState?.reset();
            });
            return;
          });
        }
        return;
      });
    }
  }

  String? validateFirstName(String value) {
    if (value.isEmpty || value.length < 3 || value.length > 15) {
      return "first name must be between 3 and 15 characters";
    }
    return null;
  }

  String? validateLastName(String value) {
    if (value.isEmpty || value.length < 3 || value.length > 20) {
      return "last name must be between 3 and 20 characters";
    }
    return null;
  }

  String? validateEmail(String value) {
    RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    bool isValid = emailRegex.hasMatch(value);
    if (value.isEmpty || value.length < 5 || !isValid || value.length > 20) {
      return "email must be valid";
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.isEmpty || value.length < 6 || value.length > 15) {
      return "Password must be of 6 characters";
    }
    return null;
  }

  String? validateConfirmPassword(String value) {
    if (passCheck != passCheckConfirm) {
      return "Passwords is not  match";
    }
    if (value.isEmpty || value.length < 6 || value.length > 15) {
      return "Password must be of 6 characters";
    }
    return null;
  }
}
