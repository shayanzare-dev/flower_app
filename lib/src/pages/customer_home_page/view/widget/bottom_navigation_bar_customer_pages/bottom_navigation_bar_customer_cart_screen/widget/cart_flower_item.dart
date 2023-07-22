import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../controller/customer_home_page_flower_controller.dart';
import '../../../../../models/cart_order_view_model.dart';

class CartFlowerItem extends GetView<CustomerHomePageFlowerController> {
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
        GestureDetector(
          child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xff8ab178),
                  borderRadius: BorderRadius.circular(20)),
              height: 45,
              width: 120,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Purchase',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Obx(
                    () => controller.isLoading.value
                        ? const CircularProgressIndicator()
                        : IconButton(
                            icon:
                                const Icon(Icons.payment, color: Colors.white),
                            onPressed: controller.isButtonEnabled.value
                                ? () => controller.onSubmitPurchaseCartOrder()
                                : null,
                          ),
                  ),
                ],
              )),
        ),

        /*InkWell(
          onTap: controller
              .isButtonEnabled.value
              ? () =>
            controller.onSubmitPurchaseCartOrder()
              : null,
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
        ),*/
      ],
    );
  }
}
