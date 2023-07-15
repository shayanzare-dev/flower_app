import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controller/vendor_home_page_flower_controller.dart';
import '../../../../../models/flower_list_view_model.dart';

class ChipItem extends StatelessWidget {
  final int index;
  final FlowerListViewModel flowerItem;

  const ChipItem({super.key, required this.index, required this.flowerItem});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorHomePageFlowerController>(
      builder: (controller) => Chip(
        
        backgroundColor: const Color(0xff04927c),
        label: Text(flowerItem.category[index],
            style: TextStyle(color: Colors.white, fontSize: 15)),
      ),
    );
  }
}
