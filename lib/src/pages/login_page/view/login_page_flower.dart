import 'package:flower_app/src/pages/login_page/view/widget/loading_widget.dart';
import 'package:flower_app/src/pages/login_page/view/widget/my_custom_login.dart';
import 'package:flutter/material.dart';

class LoginPageFlower extends StatelessWidget {
  const LoginPageFlower({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: const Text('login Page'),
            backgroundColor: const Color(0xff04927c)),
        body: const MyCustomLogin(),
        bottomNavigationBar: const LoadingWidget(),
      );
}
