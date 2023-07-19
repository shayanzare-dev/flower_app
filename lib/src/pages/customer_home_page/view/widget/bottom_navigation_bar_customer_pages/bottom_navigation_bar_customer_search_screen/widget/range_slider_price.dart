import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controller/customer_home_page_flower_controller.dart';

class CustomerRangeSliderPrice extends GetView<CustomerHomePageFlowerController> {
  const CustomerRangeSliderPrice({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RangeSlider(
        values: controller.values,
        min: 0,
        max: controller.maxPrice,
        onChanged: (values) {
          controller.setRangeValues(rangeValues: values);
        },
        labels: RangeLabels(
          '\$${controller.values.start.toInt()}',
          '\$${controller.values.end.toInt()}',
        ),
        divisions: 10,
      ),
    );
  }
}
