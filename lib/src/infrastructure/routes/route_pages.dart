import 'package:flower_app/src/pages/login_page/commons/login_page_flower_bindings.dart';
import 'package:flower_app/src/pages/login_page/view/login_page_flower.dart';
import 'package:flower_app/src/pages/register_page/view/register_page_flower.dart';
import 'package:get/get.dart';
import '../../pages/register_page/commons/register_page_flower_bindings.dart';
import 'route_names.dart';

class RoutePages {
  static final List<GetPage> pages = [
    GetPage(
      name: RouteNames.loginPageFlower,
      page: () => const LoginPageFlower(),
      binding: LoginPageFlowerBindings(),
      children: [
        GetPage(
          name: RouteNames.registerPageFlower,
          page: () => const RegisterPageFlower(),
          binding: RegisterPageFlowerBindings(),
        ),

      ],
    ),
  ];
}