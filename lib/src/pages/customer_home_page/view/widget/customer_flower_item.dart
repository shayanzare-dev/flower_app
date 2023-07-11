import 'dart:typed_data';
import 'package:flower_app/src/pages/vendor_home_page/view/widget/string_to_image_post.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../vendor_home_page/view/widget/string_to_image_profile.dart';
import '../../controller/customer_home_page_flower_controller.dart';
import '../../models/flower_list_view_model.dart';
import 'dart:convert';

class CustomerFlowerItem extends GetView<CustomerHomePageFlowerController> {
  final FlowerListViewModel flowerItem;

  const CustomerFlowerItem({
    required this.flowerItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
            onTap: () {},
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Color(0xff9ae4ec),
                borderRadius: BorderRadius.all(
                  Radius.circular(15),
                ),
              ),
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
                      height: 200,
                    ),
                    child: StringToImagePost(base64String: flowerItem.image),
                  ),
                  Row(
                    children: [
                      const Text('Flower Name : '),
                      Text(flowerItem.name),
                    ],
                  ),
                  const Row(
                    children: [
                      Text('Flower Description '),
                    ],
                  ),
                  Row(
                    children: [
                      Text(flowerItem.shortDescription),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Flower Color :'),
                      Container(
                        height: 20,
                        width: 20,
                        color: Color(flowerItem.color),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text('Flower Price :'),
                      Text(flowerItem.price.toString()),
                    ],
                  ),
                  Row(
                    children: [
/*                      IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                       // controller.editCountFlowerMinus(flowerItem);
                    },
                  )*/
                      Text('Count Flower: ${flowerItem.countInStock}'),
/*                      IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                     // controller.editCountFlowerPlus(flowerItem);
                    },
                  )*/
                    ],
                  ),
                  Row(
                    children: [
                      Text('Vendor FullName : '),
                      Text(flowerItem.vendorUser.firstName +
                          flowerItem.vendorUser.lastName),
                      SizedBox(
                          width: 40,
                          height: 40,
                          child: StringToImageProfile(
                              base64String: flowerItem.vendorUser.image))
                    ],
                  ),
                  Row(
                    children: [
                      _flowerChip(),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                             controller.editBuyCountFlowerMinus(flowerItem);
                            },
                          ),
                          Obx(() => Text(
                              'Count Buy Flower: ${controller.flowerBuyCount[flowerItem.id]}')),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                                controller.editBuyCountFlowerPlus(flowerItem);
                            },
                          ),
                        ],
                      ),
                      _myButtonAddToCart(),
                    ],
                  ),
                ],
              ),
            )),
      );

  Widget _flowerChip() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 50,
            width: 350,
            child: Column(
              children: [
                Expanded(
                  child: GetBuilder<CustomerHomePageFlowerController>(
                    builder: (controller) => ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: flowerItem.category.length,
                      itemBuilder: (_, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ChipWithDeleteIcon(
                          index,
                          flowerItem: flowerItem,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

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
                  Text('Add to Cart',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ],
              )),
          onTap: () {},
        ),
      ],
    );
  }
}

class ChipWithDeleteIcon extends StatelessWidget {
  final int index;
  final FlowerListViewModel flowerItem;

  const ChipWithDeleteIcon(this.index, {super.key, required this.flowerItem});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CustomerHomePageFlowerController>(
      builder: (controller) => Chip(
        backgroundColor: const Color(0xffb6d1ab),
        label: Text(flowerItem.category[index]),
        deleteIcon: const Icon(Icons.cancel, color: Colors.white),
        /*onDeleted: () => controller.removeChip(index),*/
      ),
    );
  }
}
