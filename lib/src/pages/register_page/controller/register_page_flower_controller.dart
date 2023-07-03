import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RegisterPageFlowerController extends GetxController {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passWordController = TextEditingController();
  final TextEditingController passWordConfirmController =
      TextEditingController();
  String passCheckConfirm = '';
  String passCheck = '';

  RxInt selectedTypeUser = 1.obs;
  void selectedTypeUserValue(int value) {
    selectedTypeUser.value = value;
  }
  RxBool obscureText = true.obs;
  RxBool obscureTextConfirm = true.obs;

  File? imageFile;
  String base64Image="";




  Future<void> getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      update();
      if (imageFile != null){
        List<int> imageBytes  = await pickedFile.readAsBytes();
        base64Image =  base64Encode(imageBytes);
      }
    } else {
      print('No image selected.');
    }
  }

  @override
  void onInit() {
    super.onInit();
  }
  String? validateFirstName(String value) {
    if (value.isEmpty || value.length < 3) {
      return "Password must be of 6 characters";
    }
    return null;
  }

  String? validateLastName(String value) {
    if (value.isEmpty || value.length < 3) {
      return "Password must be of 6 characters";
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
