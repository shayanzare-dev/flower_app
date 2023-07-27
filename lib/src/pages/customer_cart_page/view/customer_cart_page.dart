import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      body: Obx(() =>  _customerCartList()),
    );
  }

  Widget _customerCartList() {
    if (controller.cartOrderList.isEmpty) {
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
