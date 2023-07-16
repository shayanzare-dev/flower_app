import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/vendor_add_flower_page_controller.dart';



class ChipItem extends StatelessWidget {
  final int index;


  const ChipItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorAddFlowerPageController>(
      builder: (controller) => Chip(
        backgroundColor: const Color(0xffb6d1ab),
        label: Text(controller.categoryChips[index]),
        deleteIcon: const Icon(Icons.cancel, color: Colors.white),
        onDeleted: () => controller.removeChip( index: index,),
      ),
    );
  }
}
