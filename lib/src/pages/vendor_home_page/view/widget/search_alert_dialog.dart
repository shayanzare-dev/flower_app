import 'package:flower_app/src/pages/vendor_home_page/view/widget/range_slider_price.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/vendor_home_page_flower_controller.dart';
import '../../models/flower_list_view_model.dart';
import 'check_box_color_filter.dart';
import 'dropdown_button.dart';

class SearchAlertDialog extends GetView<VendorHomePageFlowerController> {
  const SearchAlertDialog({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Search Filter'),
            content: Container(
              height: 400,
              width: 200,
                child: Column(
                  children: [
                    MyDropdownButton(),
                    SizedBox(
                        height: 200,
                        width: 170,
                        child: CheckBoxColorFilter()),
                    RangeSliderPrice(),
                  ],
                ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => controller.clearSearchFilterFlowers(),
                child: const Text('clear Filter'),
              ),
              TextButton(
                onPressed: () => controller.getSearchFilterFlowerList(),
                child: const Text('OK'),
              )
            ],
          ),
        ),
        icon: const Icon(Icons.search),
      );
}
