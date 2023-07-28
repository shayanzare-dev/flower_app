import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../flower_app.dart';
import '../../../../generated/locales.g.dart';
import '../controller/customer_home_page_flower_controller.dart';
import 'widget/bottom_navigation_bar_customer_pages/bottom_navigation_bar_customer_home_screen/bottom_navigation_bar_customer_home_screen.dart';

class CustomerHomePageFlower extends GetView<CustomerHomePageFlowerController> {
  CustomerHomePageFlower({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: const Icon(Icons.menu),
            ),
            automaticallyImplyLeading: false,
            actions: [
              Row(
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
              ),
            ],
            title: Text(LocaleKeys.customer_page_title.tr),
            backgroundColor: const Color(0xff04927c)),
        drawer: Drawer(
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
                  Get.offAndToNamed(RouteNames.loadingPageFlower +
                      RouteNames.loginPageFlower);
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
        ),
        body: const CustomerHomeScreen(),

        /*  Obx(() => CustomerHomePageFlowerController.widgetOptionsNavBar
            .elementAt(controller.selectedIndex.value)),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            fixedColor: Colors.white,
            backgroundColor: const Color(0xff8ab178),
            currentIndex: controller.selectedIndex.value,
            onTap: (value) {
              controller.onItemTappedNavBar(navBarIndex: value);
            },
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: LocaleKeys.customer_page_home.tr,
              ),
              BottomNavigationBarItem(
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
                label: LocaleKeys.customer_page_cart.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.search),
                label: LocaleKeys.customer_page_search.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.history),
                label: LocaleKeys.customer_page_history.tr,
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person),
                label: LocaleKeys.customer_page_profile.tr,
              ),
            ],
          ),
        ),*/
      );
}
