import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../login_page/controller/login_page_flower_controller.dart';
import '../../controller/vendor_home_page_flower_controller.dart';

class ProfileScreen extends GetView<VendorHomePageFlowerController> {
  ProfileScreen({super.key});

  final loginPageFlowerController = Get.put(LoginPageFlowerController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _myButtonSignOut(),
      ],
    );
  }

  Widget _myButtonSignOut() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            child: Container(
                decoration: BoxDecoration(
                    color: const Color(0xff159947),
                    borderRadius: BorderRadius.circular(20)),
                height: 45,
                width: 100,
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sign Out',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                )),
            onTap: () {
              loginPageFlowerController.clearLoginStatus();
              controller.goToLoginPage();
            },
          ),

         Text(controller.vendorUser.first.firstName),
        ],
      ),
    );
  }
}
