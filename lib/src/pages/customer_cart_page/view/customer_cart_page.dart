import 'package:flutter/material.dart';
import '../view/widget/bought_list.dart';
import '../view/widget/cart_flower_list.dart';

class CustomerCartFlowerPage extends StatelessWidget {
  const CustomerCartFlowerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Cart Flower page'),
          backgroundColor: const Color(0xff04927c)),
      body: ListView(
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
      ),
    );
  }
}
