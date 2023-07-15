import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/customer_home_page_flower_controller.dart';
import 'widget/bought_list.dart';
import 'widget/cart_flower_list.dart';

class CustomerCartScreen extends GetView<CustomerHomePageFlowerController> {
  const CustomerCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        SizedBox(
          height: 550,
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
