import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../generated/locales.g.dart';
import '../../../../../controller/customer_home_page_flower_controller.dart';
import '../../../../../models/flower_list_view_model.dart';

class AddToCartBtn extends GetView<CustomerHomePageFlowerController> {
  final FlowerListViewModel flowerItem;

  const AddToCartBtn({Key? key, required this.flowerItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.addFlowerToBoughtFlowers(flowerItem: flowerItem);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff54786c),
          borderRadius: BorderRadius.circular(25.0),
        ),
        child:  Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Text(
            LocaleKeys.customer_home_item_add_cart_btn.tr,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
