import 'dart:typed_data';
import 'package:flower_app/src/pages/customer_home_page/models/bought_flowers_view_model.dart';
import 'package:flower_app/src/pages/vendor_home_page/view/widget/string_to_image_post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/vendor_home_page_flower_controller.dart';


class VendorBoughtItem extends GetView<VendorHomePageFlowerController> {
  final BoughtFlowers boughtFlower;

  const VendorBoughtItem({
    required this.boughtFlower,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
            onTap: () {},
            child: Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  constraints: const BoxConstraints.expand(
                    height: 100,
                  ),
                  child: StringToImagePost(
                      base64String: boughtFlower.flowerListViewModel.image),
                ),
                Row(
                  children: [
                    Text('Flower Name : '),
                    Text(boughtFlower.flowerListViewModel.name),
                  ],
                ),
                Row(
                  children: [
                    Text('Flower buy count : '),
                    Text(boughtFlower.buyCount.toString()),
                  ],
                ),
                Row(
                  children: [
                    Text('customer Flower name : '),
                    Text(boughtFlower.user.firstName),
                    Text(boughtFlower.user.lastName),
                  ],
                ),
                Row(
                  children: [
                    Text('date : '),
                    Text(boughtFlower.dateTime),
                  ],
                ),
              ],
            )),
      );

  Widget _myButtonAddToCart() {
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
            // controller.addFlowerToBoughtFlowers(cartOrderItem);
          },
        ),
      ],
    );
  }
}
