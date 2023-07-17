import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/vendor_search_page_controller.dart';



class VendorRangeSliderPrice1 extends GetView<VendorSearchPageController> {
  const VendorRangeSliderPrice1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RangeSlider(
        values: controller.values,
        min: 0,
        max: 1000,
        onChanged: (values) {
          controller.setValues(rangeValues: values);
        },
        labels: RangeLabels(
          '\$${controller.values.start.toInt()}',
          '\$${controller.values.end.toInt()}',
        ),
        divisions: 100,
      ),
    );
  }
}
