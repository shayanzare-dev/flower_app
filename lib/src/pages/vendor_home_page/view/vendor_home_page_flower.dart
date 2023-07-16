import 'dart:convert';

import 'package:flower_app/flower_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/vendor_home_page_flower_controller.dart';

class VendorHomePageFlower extends GetView<VendorHomePageFlowerController> {
  VendorHomePageFlower({Key? key}) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) => Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
              icon: Icon(Icons.menu),
            ),
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
            title: const Text('Vendor Home page'),
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
                  'Vendor Menu',
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
                leading: const Icon(Icons.add),
                title: const Text('Add Flowers'),
                onTap: () {
                  Get.toNamed(RouteNames.loginPageFlower+RouteNames.vendorHomePageFlower+RouteNames.addFlowerPage);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.search),
                title: const Text('Search'),
                onTap: () {
                  Get.toNamed(RouteNames.loginPageFlower+RouteNames.vendorHomePageFlower+RouteNames.vendorSearchPage);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('History'),
                onTap: () {
                  Get.toNamed(RouteNames.loginPageFlower+RouteNames.vendorHomePageFlower+RouteNames.vendorHistoryPage);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Get.toNamed(RouteNames.loginPageFlower+RouteNames.vendorHomePageFlower+RouteNames.vendorProfilePage);
                  Navigator.pop(context);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.output_rounded),
                title: const Text('Sign out'),
                onTap: () {
                  controller.clearLoginStatus();
                  Get.offAndToNamed(RouteNames.loginPageFlower);
                  Navigator.pop(context);
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
        body: Obx(() => VendorHomePageFlowerController.widgetOptionsNavBar
            .elementAt(controller.selectedIndexNavBar.value)),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            fixedColor: Colors.white,
            backgroundColor: const Color(0xff8ab178),
            currentIndex: controller.selectedIndexNavBar.value,
            onTap: (value) {
              controller.onItemTappedNavBar(index: value);
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Add Flowers',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Search',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        ),
      );
}
