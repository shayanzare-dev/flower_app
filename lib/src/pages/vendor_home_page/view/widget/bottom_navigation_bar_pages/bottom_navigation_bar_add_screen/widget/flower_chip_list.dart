import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../controller/vendor_home_page_flower_controller.dart';
import 'add_chip.dart';
import 'chip_item.dart';

class FlowerChipList extends GetView<VendorHomePageFlowerController> {
  const FlowerChipList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 350,
                child: Column(
                  children: [
                    const AddChipTextField(),
                    Expanded(
                      child: Obx(
                        () => ListView.builder(
                          shrinkWrap: true,
                          itemCount: controller.suggestions.length,
                          itemBuilder: (context, index) {
                            final suggestion = controller.suggestions[index];
                            return ListTile(
                              title: Text(suggestion),
                              onTap: () {
                                controller.categoryTextController.text =
                                    suggestion;
                                controller.addChip();
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: GetBuilder<VendorHomePageFlowerController>(
                        builder: (controller) => Obx(
                          () => ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.categoryChips.length,
                            itemBuilder: (_, index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              child: ChipItem(
                                index: index,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // if (controller.suggestions.isNotEmpty)
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
