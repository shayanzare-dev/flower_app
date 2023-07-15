import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/vendor_home_page_flower_controller.dart';

class VendorHomePageFlower extends GetView<VendorHomePageFlowerController> {
  const VendorHomePageFlower({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
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
            title: const Text('Vendor Home page flower'),
            backgroundColor: const Color(0xff04927c)),
        body: Obx(() => VendorHomePageFlowerController.widgetOptionsNavBar.elementAt(controller.selectedIndexNavBar.value)),
        bottomNavigationBar: Obx(
          () => BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            fixedColor: Colors.white,
            backgroundColor: const Color(0xff8ab178),
            currentIndex: controller.selectedIndexNavBar.value,
            onTap:(value) {
              controller.onItemTappedNavBar( index: value);
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
