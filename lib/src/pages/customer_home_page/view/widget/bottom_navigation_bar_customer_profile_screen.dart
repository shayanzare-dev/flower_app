import 'package:flower_app/src/pages/customer_home_page/view/widget/string_to_image_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../login_page/controller/login_page_flower_controller.dart';
import '../../controller/customer_home_page_flower_controller.dart';


class CustomerProfileScreen extends GetView<CustomerHomePageFlowerController> {
  CustomerProfileScreen({super.key});

  final loginPageFlowerController = Get.put(LoginPageFlowerController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            width: 200,
            height: 200,
            child: StringToImageProfile(base64String: controller.customerUser.first.image)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('First Name : '),
            Text(controller.customerUser.first.firstName),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Last Name : '),
            Text(controller.customerUser.first.lastName),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Email : '),
            Text(controller.customerUser.first.email),
          ],
        ),

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
        ],
      ),
    );
  }
}
