import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../generated/locales.g.dart';
import '../../customer_home_page/controller/customer_home_page_flower_controller.dart';

class CustomerProfilePage extends StatelessWidget {
  CustomerProfilePage({Key? key}) : super(key: key);
  final customerHomePageFlowerController =
      Get.put(CustomerHomePageFlowerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Profile page'),
          backgroundColor: const Color(0xff04927c)),
      body: SizedBox(
        width: 400,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff04927c), Color(0xff8ab178)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _imageProfile(),
                const SizedBox(height: 10.0),
                _name(),
                _lastName(),
                const SizedBox(height: 10.0),
                _email(),
                const SizedBox(height: 30.0),
                _signOutButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _signOutButton() {
    return ElevatedButton(
      onPressed: () {
        customerHomePageFlowerController.clearLoginStatus();
        customerHomePageFlowerController.goToLoginPage();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey,
      ),
      child: Text(
        LocaleKeys.profile_sign_out_btn.tr,
        style: const TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Row _email() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          LocaleKeys.profile_email.tr,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          customerHomePageFlowerController.customerUser.first.email,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Row _lastName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          LocaleKeys.profile_last_name.tr,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          customerHomePageFlowerController.customerUser.first.lastName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Row _name() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          LocaleKeys.profile_first_name.tr,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          customerHomePageFlowerController.customerUser.first.firstName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _imageProfile() {
    return _showImage();
  }

  Widget _showImage() {
    if (customerHomePageFlowerController.customerUser.first.image == '') {
      return Container(
        alignment: AlignmentDirectional.center,
        height: 150,
        width: 150,
        decoration: BoxDecoration(
          color: const Color(0xff159947),
          borderRadius: BorderRadius.circular(1000),
        ),
        child: const Icon(
          Icons.person,
          size: 50,
          color: Colors.white,
        ),
      );
    }
    return SizedBox(
      width: 150,
      height: 150,
      child: CircleAvatar(
        backgroundImage: MemoryImage(base64Decode(
            customerHomePageFlowerController.customerUser.first.image)),
        radius: 50.0,
      ),
    );
  }
}
