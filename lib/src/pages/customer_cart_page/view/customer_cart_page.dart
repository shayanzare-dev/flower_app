import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../flower_app.dart';
import '../../../../generated/locales.g.dart';
import '../controller/customer_cart_page_controller.dart';
import '../view/widget/bought_list.dart';
import '../view/widget/cart_flower_list.dart';

class CustomerCartFlowerPage extends GetView<CustomerCartPageController> {
  const CustomerCartFlowerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Cart Flower page'),
          backgroundColor: const Color(0xff04927c)),
      drawer: _drawer(context),
      body: Obx(() => _customerCartList()),
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
          const Divider(),
          ListTile(
            leading: const Icon(Icons.output_rounded),
            title: Text(LocaleKeys.profile_sign_out_btn.tr),
            onTap: () {
              controller.clearLoginStatus();
              Get.offAndToNamed(
                  RouteNames.loadingPageFlower + RouteNames.loginPageFlower);
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

  Widget _customerCartList() {
    if (controller.isLoadingCartListPage.value) {
      return const Center(child: CircularProgressIndicator());
    } else if (controller.cartOrderList.isEmpty) {
      return const Center(
        child: Text('Cart List Is Empty',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Color(0xff04927c))),
      );
    }
    return ListView(
      children: const <Widget>[
        SizedBox(
          height: 630,
          child: BoughtList(),
        ),
        SizedBox(
          height: 100,
          child: CartFlowerList(),
        ),
      ],
    );
  }
}
