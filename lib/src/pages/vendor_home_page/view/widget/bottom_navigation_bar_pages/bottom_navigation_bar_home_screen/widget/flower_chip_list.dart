import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../controller/vendor_home_page_flower_controller.dart';
import '../../../../../models/flower_list_view_model.dart';
import 'chip_item.dart';

class FlowerChipList extends StatelessWidget {
  final FlowerListViewModel flowerItem;
  const FlowerChipList({Key? key, required this.flowerItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
            width: 300,
            child: Column(
              children: [
                Expanded(
                  child: GetBuilder<VendorHomePageFlowerController>(
                    builder: (controller) => ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: flowerItem.category.length,
                      itemBuilder: (_, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: ChipItem(
                          flowerItem: flowerItem,
                          index: index,
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
}
