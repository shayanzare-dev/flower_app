import 'package:flower_app/src/pages/register_page/view/widget/loading_widget.dart';
import 'package:flower_app/src/pages/register_page/view/widget/my_custom_register.dart';
import 'package:flutter/material.dart';

class RegisterPageFlower extends StatelessWidget {
  const RegisterPageFlower({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Register Page'),backgroundColor:const Color(0xff04927c) ),
    body: const MyCustomRegister(),
    bottomNavigationBar: const LoadingWidget(),
  );
}
