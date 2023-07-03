import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/login_page_flower_controller.dart';

class MyCustomLogin extends GetView<LoginPageFlowerController> {
  const MyCustomLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Form(
        key: controller.loginFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _iconUser(),
              _inputEmail(),
              _inputPassword(),
              _myButton(context),
              _myButtonSignUp(),
            ],
          ),
        ),
      );

  Widget _iconUser() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    alignment: AlignmentDirectional.center,
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Color(0xff159947),
                      borderRadius: BorderRadius.circular(1000),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _inputEmail() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: const Color(0xff88d79f),
            borderRadius: BorderRadius.circular(40)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            controller: controller.emailController,
            decoration: const InputDecoration(
              icon: Icon(Icons.person, color: Colors.white),
              border: InputBorder.none,
              label: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  'email',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            validator: (value) {
              return controller.validateEmail(value!);
            },
          ),
        ),
      ),
    );
  }

  Widget _inputPassword() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: const Color(0xff88d79f),
            borderRadius: BorderRadius.circular(40)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Obx(
            () => TextFormField(
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
              controller: controller.passWordController,
              obscureText: controller.obscureText.value,
              decoration: InputDecoration(
                  icon: const Icon(Icons.lock, color: Colors.white),
                  suffixIcon: IconButton(
                      onPressed: () {
                        controller.obscureText.value =
                            !controller.obscureText.value;
                      },
                      icon: Icon(
                        controller.obscureText.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white,
                      )),
                  border: InputBorder.none,
                  label: const Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Text(
                      'password',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              validator: (value) {
                return controller.validatePassword(value!);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _myButton(BuildContext context) {
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
                    Text('login',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                )),
            onTap: () {
              controller.checkLogin();
            },
          ),
        ],
      ),
    );
  }

  Widget _myButtonSignUp() {
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
                    Text('Sign Up',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                )),
            onTap: () {
              controller.goToRegisterPage();
            },
          ),
        ],
      ),
    );
  }
}
