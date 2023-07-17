import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../flower_app.dart';
import '../controller/customer_home_page_flower_controller.dart';

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
              icon: Icon(Icons.menu),
            ),
            automaticallyImplyLeading: false,
            actions: [
              Row(
                children: [
                  const Text('Refresh'),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () {
                      controller.refresh();
                    },
                  ),
                ],
              ),
            ],
            title: const Text('Customer Home page'),
            backgroundColor: const Color(0xff04927c)),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xff04927c),
                ),
                child: Text(
                  'Customer Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
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
                title: const Text('Cart Flowers'),
                onTap: () {
                  Get.toNamed(RouteNames.loadingPageFlower+RouteNames.loginPageFlower+RouteNames.customerHomePageFlower+RouteNames.customerCartPage);

                },
              ),
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Search'),
                onTap: () {
                  Get.toNamed(RouteNames.loadingPageFlower+RouteNames.loginPageFlower+RouteNames.customerHomePageFlower+RouteNames.customerSearchPage);

                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('History'),
                onTap: () {
                  Get.toNamed(RouteNames.loadingPageFlower+RouteNames.loginPageFlower+RouteNames.customerHomePageFlower+RouteNames.customerHistoryPage);

                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Get.toNamed(RouteNames.loadingPageFlower+RouteNames.loginPageFlower+RouteNames.customerHomePageFlower+RouteNames.customerProfilePage);

                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.output_rounded),
                title: const Text('Sign out'),
                onTap: () {
                  controller.clearLoginStatus();
                  Get.offAndToNamed(RouteNames.loadingPageFlower+RouteNames.loginPageFlower);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('English'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('فارسی'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: Obx(() => CustomerHomePageFlowerController.widgetOptionsNavBar
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
              const BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
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
                label: 'Cart',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'History',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      );
}
