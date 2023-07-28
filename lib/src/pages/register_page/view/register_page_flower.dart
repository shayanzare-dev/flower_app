import 'package:flower_app/src/pages/register_page/view/widget/my_custom_register.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/locales.g.dart';

class RegisterPageFlower extends StatelessWidget {
  const RegisterPageFlower({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: Text(LocaleKeys.register_title.tr),
            backgroundColor: const Color(0xff04927c)),
        body: const MyCustomRegister(),

      );
}
