import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/vendor_search_page_controller.dart';


class MyDropdownButton extends GetView<VendorSearchPageController> {
  const MyDropdownButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Obx(
        () => DropdownButton(
          isExpanded: true,
          borderRadius: BorderRadius.circular(10),
          value: controller.selectedItemDropDown.value,
          items: controller.dropDownButtonList.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (value) {
            controller.selectedItemDropDown.value = value!;
          },
        ),
      );
}
