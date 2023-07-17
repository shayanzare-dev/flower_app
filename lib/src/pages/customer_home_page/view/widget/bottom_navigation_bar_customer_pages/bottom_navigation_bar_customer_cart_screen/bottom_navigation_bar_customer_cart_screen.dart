import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/customer_home_page_flower_controller.dart';
import 'widget/bought_list.dart';
import 'widget/cart_flower_list.dart';
import '../../loading_widget.dart';

class CustomerCartScreen extends GetView<CustomerHomePageFlowerController> {
  const CustomerCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const <Widget>[
        SizedBox(
          height: 580,
          child: BoughtList(),
        ),
        const Stack(
          children: <Widget>[
            Center(
              child: LoadingWidget(),
            ),
          ],
        ),
        SizedBox(
          height: 100,
          child: CartFlowerList(),
        ),

      ],
    );
  }
}
