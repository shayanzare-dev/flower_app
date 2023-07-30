import 'package:flower_app/generated/locales.g.dart';
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
                     Text( LocaleKeys.customer_home_item_total_price.tr,
                        style: const TextStyle(
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
    return Obx(() =>  _purchaseBtnLoading());
  }

  Widget _purchaseBtnLoading(){
    if(controller.isLoadingCartPurchaseBtn.value){
      return const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
        ],
      );
    }
    return Row(
      children: [
        InkWell(
          child: Container(
              decoration: BoxDecoration(
                  color: const Color(0xff8ab178),
                  borderRadius: BorderRadius.circular(20)),
              height: 45,
              width: 90,
              child:  Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(LocaleKeys.customer_home_item_purchase.tr,
                      style: const TextStyle(
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
