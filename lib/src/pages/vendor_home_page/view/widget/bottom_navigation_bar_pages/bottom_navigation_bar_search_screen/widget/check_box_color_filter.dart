import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controller/vendor_home_page_flower_controller.dart';
import '../../../../../../shared/grid_item.dart';

class CheckBoxColorFilter extends GetView<VendorHomePageFlowerController> {
  const CheckBoxColorFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VendorHomePageFlowerController>(
      builder: (_) => SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.2,
        child: Obx(
          () => GridView.builder(
            shrinkWrap: true,
            itemCount: controller.colorItems.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              childAspectRatio: 1,
            ),
            itemBuilder: (BuildContext context, int index) {
              GridItem item = controller.colorItems[index];
              return InkWell(
                onTap: () {
                  controller.colorToggleSelection( colorToggleIndex: index);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: item.color,
                  ),
                  child: item.isSelected
                      ? Align(
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: Icon(
                              Icons.check,
                              size: 20,
                              color: item.color,
                            ),
                          ),
                        )
                      : null,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
