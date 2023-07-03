import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controller/register_page_flower_controller.dart';

class MyCustomRegister extends GetView<RegisterPageFlowerController> {
  const MyCustomRegister({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Form(
        key: controller.loginFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _iconUser(),
              _inputFirstName(),
              _inputLastName(),
              _inputEmail(),
              _inputPassword(),
              _inputPasswordConfirm(),
              _inputTypeOfUser(),
              _myButton(context),
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
                      color: Colors.cyan,
                      borderRadius: BorderRadius.circular(1000),
                      border: Border.all(width: 3, color: Colors.white),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  PositionedDirectional(
                    bottom: 9,
                    start: 9,
                    child: Material(
                      color: Colors.lightBlueAccent[100],
                      borderRadius: BorderRadius.circular(100),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {
                          controller.getImage(ImageSource.gallery);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border:
                                  Border.all(width: 4, color: Colors.white)),
                          width: 35,
                          height: 35,
                          child: const Icon(Icons.camera_alt,
                              size: 20, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _inputFirstName() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: const Color(0xff88d79f),
            borderRadius: BorderRadius.circular(40)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextFormField(
            keyboardType: TextInputType.name,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            controller: controller.firstNameController,
            decoration: const InputDecoration(
              icon: Icon(Icons.person, color: Colors.white),
              border: InputBorder.none,
              label: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  'First name',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            validator: (value) {
              return controller.validateFirstName(value!);
            },
          ),
        ),
      ),
    );
  }

  Widget _inputLastName() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: const Color(0xff88d79f),
            borderRadius: BorderRadius.circular(40)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextFormField(
            keyboardType: TextInputType.name,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            controller: controller.lastNameController,
            decoration: const InputDecoration(
              icon: Icon(Icons.person, color: Colors.white),
              border: InputBorder.none,
              label: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  'Last name',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            validator: (value) {
              return controller.validateLastName(value!);
            },
          ),
        ),
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
              icon: Icon(Icons.mail, color: Colors.white),
              border: InputBorder.none,
              label: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  'Email',
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
              onChanged: (value) {
                controller.passCheck = value;
              },
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

  Widget _inputPasswordConfirm() {
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
              onChanged: (value) {
                controller.passCheckConfirm = value;
              },
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
              controller: controller.passWordConfirmController,
              obscureText: controller.obscureTextConfirm.value,
              decoration: InputDecoration(
                  icon: const Icon(Icons.lock, color: Colors.white),
                  suffixIcon: IconButton(
                      onPressed: () {
                        controller.obscureTextConfirm.value =
                            !controller.obscureTextConfirm.value;
                      },
                      icon: Icon(
                        controller.obscureTextConfirm.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.white,
                      )),
                  border: InputBorder.none,
                  label: const Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: Text(
                      'Confirm Password',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
              validator: (value) {
                return controller.validateConfirmPassword(value!);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _inputTypeOfUser() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: Colors.green[200], borderRadius: BorderRadius.circular(40)),
        child: Row(
          children: [
            Expanded(
              child: Obx(
                () => RadioListTile(
                  title: const Text(
                    'Vendor',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  value: 1,
                  groupValue: controller.selectedTypeUser.value,
                  onChanged: (value) {
                    controller.selectedTypeUserValue(value!);
                  },
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () => RadioListTile(
                  title: const Text(
                    'Customer',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  value: 2,
                  groupValue: controller.selectedTypeUser.value,
                  onChanged: (value) {
                    controller.selectedTypeUserValue(value!);
                  },
                ),
              ),
            ),
          ],
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
                    Text('Register',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                )),
            onTap: () {
              // controller.checkLogin();

              print(controller.base64Image);
            },
          ),
        ],
      ),
    );
  }
}
