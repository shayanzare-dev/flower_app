import 'package:flower_app/flower_app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../generated/locales.g.dart';
import '../controller/vendor_home_page_flower_controller.dart';
import 'widget/home_page/home_screen.dart';

class VendorHomePageFlower extends GetView<VendorHomePageFlowerController> {
  const VendorHomePageFlower({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              controller.scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
          actions: [
            Row(
              children: [
                Text(LocaleKeys.vendor_page_refresh.tr),
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
          title: Text(LocaleKeys.vendor_page_title.tr),
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
                LocaleKeys.vendor_page_title.tr,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(LocaleKeys.vendor_page_home.tr),
              onTap: () {
                Get.offAllNamed(RouteNames.vendorHomePageFlower);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: Text(LocaleKeys.vendor_page_add_flower.tr),
              onTap: () {
                Get.offAllNamed(
                    RouteNames.vendorHomePageFlower + RouteNames.addFlowerPage);
              },
            ),
            ListTile(
              leading: const Icon(Icons.search),
              title: Text(LocaleKeys.vendor_page_search.tr),
              onTap: () {
                Get.toNamed(RouteNames.vendorHomePageFlower +
                    RouteNames.vendorSearchPage);
              },
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: Text(LocaleKeys.vendor_page_history.tr),
              onTap: () {
                Get.toNamed(RouteNames.vendorHomePageFlower +
                    RouteNames.vendorHistoryPage);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(LocaleKeys.vendor_page_profile.tr),
              onTap: () {
                Get.toNamed(RouteNames.vendorHomePageFlower +
                    RouteNames.vendorProfilePage);
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
              title: Text(LocaleKeys.vendor_page_about.tr),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: const HomeScreen());
}
