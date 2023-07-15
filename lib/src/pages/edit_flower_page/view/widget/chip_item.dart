import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/edit_flower_page_controller.dart';

class ChipItem extends StatelessWidget {
  final int index;


  const ChipItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditFlowerPageController>(
      builder: (controller) => Chip(
        backgroundColor: const Color(0xffb6d1ab),
        label: Text(controller.categoryChips[index]),
        deleteIcon: const Icon(Icons.cancel, color: Colors.white),
        onDeleted: () => controller.removeChip(index),
      ),
    );
  }
}
