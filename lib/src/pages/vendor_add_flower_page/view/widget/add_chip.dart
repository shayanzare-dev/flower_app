import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/vendor_add_flower_page_controller.dart';

class AddChipTextField extends StatelessWidget {
  const AddChipTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorAddFlowerPageController>(
      builder: (controller) => TextField(
        controller: controller.categoryTextController,
        decoration: InputDecoration(
          hintText: 'Add a Category',
          hintStyle: const TextStyle(
              color: Color(0xff04927c),
              fontSize: 20,
              fontWeight: FontWeight.bold),
          suffixIcon: IconButton(
            icon: const Icon(Icons.add, color: Color(0xff04927c)),
            onPressed: controller.addChip,
          ),
        ),
        onChanged: (text) => controller.updateSuggestions(text),
        onSubmitted: (_) => controller.addChip(),
      ),
    );
  }
}