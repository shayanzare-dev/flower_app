import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../flower_app.dart';
import '../../../../generated/locales.g.dart';
import '../controller/customer_home_page_flower_controller.dart';
import 'widget/home_page/customer_home_screen.dart';

class CustomerHomePageFlower extends GetView<CustomerHomePageFlowerController> {
  const CustomerHomePageFlower({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        key: controller.scaffoldKey,
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                controller.scaffoldKey.currentState?.openDrawer();
              },
              icon: const Icon(Icons.menu),
            ),
            automaticallyImplyLeading: false,
            actions: [
              _cartAndRefreshIcon(),
            ],
            title: Text(LocaleKeys.customer_page_title.tr),
            backgroundColor: const Color(0xff04927c)),
        drawer: _drawer(context),
        body: const CustomerHomeScreen(),
      );

  Widget _cartAndRefreshIcon() {
    return Row(
      children: [
        IconButton(
          icon: Stack(children: [
            const Icon(Icons.shopping_cart),
            Obx(() {
              int cartCount = controller.cartCount.value;
              if (cartCount == 0) {
                return const SizedBox.shrink();
              } else {
                return Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            }),
          ]),
          onPressed: () {
            Get.toNamed(RouteNames.customerHomePageFlower +
                RouteNames.customerCartPage);
          },
        ),
        Obx(
          () => IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.isButtonEnabled.value
                ? () => controller.refresh()
                : null,
          ),
        ),
      ],
    );
  }

  Drawer _drawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xff04927c),
            ),
            child: Text(
              LocaleKeys.customer_page_title.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(LocaleKeys.customer_page_home.tr),
            onTap: () {
              Get.offAllNamed(RouteNames.customerHomePageFlower);
            },
          ),
          ListTile(
            leading: Stack(children: [
              const Icon(Icons.shopping_cart),
              Obx(() {
                int cartCount = controller.cartCount.value;
                if (cartCount == 0) {
                  return const SizedBox.shrink();
                } else {
                  return Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$cartCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              }),
            ]),
            title: Text(LocaleKeys.customer_page_cart.tr),
            onTap: () {
              Get.offAllNamed(RouteNames.customerHomePageFlower +
                  RouteNames.customerCartPage);
            },
          ),
          ListTile(
            leading: const Icon(Icons.search),
            title: Text(LocaleKeys.customer_page_search.tr),
            onTap: () {
              Get.toNamed(RouteNames.customerHomePageFlower +
                  RouteNames.customerSearchPage);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: Text(LocaleKeys.customer_page_history.tr),
            onTap: () {
              Get.toNamed(RouteNames.customerHomePageFlower +
                  RouteNames.customerHistoryPage);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: Text(LocaleKeys.customer_page_profile.tr),
            onTap: () {
              Get.toNamed(RouteNames.customerHomePageFlower +
                  RouteNames.customerProfilePage);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.output_rounded),
            title: Text(LocaleKeys.profile_sign_out_btn.tr),
            onTap: () {
              controller.clearLoginStatus();
              Get.offAllNamed(RouteNames.loginPageFlower);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('English'),
            onTap: () {
              Get.updateLocale(const Locale('en', 'US'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('فارسی'),
            onTap: () {
              Get.updateLocale(const Locale('fa', 'IR'));
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: Text(LocaleKeys.customer_page_about.tr),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
