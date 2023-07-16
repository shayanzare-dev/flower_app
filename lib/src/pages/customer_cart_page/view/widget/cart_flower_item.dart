import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../customer_home_page/models/cart_order_view_model.dart';
import '../../controller/customer_cart_page_controller.dart';



class CartFlowerItem extends GetView<CustomerCartPageController> {
  final CartOrderViewModel cartOrderItem;

  const CartFlowerItem({
    required this.cartOrderItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    const Text('Total Price: ',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff04927c),
                            fontSize: 20)),
                    Text(cartOrderItem.totalPrice.toString(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xff04927c),
                            fontSize: 20)),
                  ],
                ),
                _myButtonPurchase(),
              ],
            ),
          ),
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
