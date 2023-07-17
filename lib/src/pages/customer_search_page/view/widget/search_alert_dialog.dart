import 'package:flower_app/src/pages/customer_search_page/view/widget/range_slider_price.dart';
import 'package:flower_app/src/pages/customer_search_page/view/widget/check_box_color_filter.dart';
import 'package:flower_app/src/pages/customer_search_page/view/widget/dropdown_button.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../customer_home_page/controller/customer_home_page_flower_controller.dart';



class SearchAlertDialog extends GetView<CustomerHomePageFlowerController> {
  const SearchAlertDialog({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Search Filter'),
            content: const SizedBox(
              height: 300,
              width: 200,
              child: Column(
                children: [
                  MyDropdownButton(),
                  SizedBox(height: 8),
                  Text('Color Filter',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff04927c),
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  CheckBoxColorFilter(),
                  SizedBox(height: 8),
                  Text('Price Range Filter',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff04927c),
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  CustomerRangeSliderPrice1(),
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
        icon: const Icon(Icons.manage_search),
      );
}
