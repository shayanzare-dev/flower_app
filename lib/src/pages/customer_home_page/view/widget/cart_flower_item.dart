import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/customer_home_page_flower_controller.dart';
import '../../models/cart_order_view_model.dart';


class CartFlowerItem extends GetView<CustomerHomePageFlowerController> {
  final CartOrderViewModel cartOrderItem;

  const CartFlowerItem({
    required this.cartOrderItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          Text(cartOrderItem.totalPrice.toString()),
        ],
      ),
      _myButtonPurchase(),
    ],
  );




  Widget _myButtonPurchase() {
    return Row(
      children: [
        InkWell(
          child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xff8ab178),
                  borderRadius: BorderRadius.circular(20)),
              height: 45,
              width: 90,
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Purchase',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ],
              )),
          onTap: () {
             controller.onSubmitPurchaseCartOrder();
          },
        ),
      ],
    );
  }

}
