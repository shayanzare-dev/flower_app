import 'package:flower_app/src/pages/customer_search_page/view/widget/range_slider_price.dart';
import 'package:flower_app/src/pages/customer_search_page/view/widget/check_box_color_filter.dart';
import 'package:flower_app/src/pages/customer_search_page/view/widget/dropdown_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../generated/locales.g.dart';
import '../../controller/customer_search_page_controller.dart';



class SearchAlertDialog extends GetView<CustomerSearchPageController> {
  const SearchAlertDialog({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text(LocaleKeys.home_search_search_filter.tr),
            content:  SizedBox(
              height: 300,
              width: 200,
              child: Column(
                children: [
                  const MyDropdownButton(),
                  const SizedBox(height: 8),
                  Text(LocaleKeys.home_search_search_color.tr,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xff04927c),
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const CheckBoxColorFilter(),
                  const SizedBox(height: 8),
                  Text(LocaleKeys.home_search_search_price.tr,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xff04927c),
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const CustomerRangeSliderPrice1(),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => controller.clearSearchFilterFlowers(context: context),
                child: Text(LocaleKeys.home_search_search_clear_btn.tr),
              ),
              TextButton(
                onPressed: () => controller.getSearchFilterFlowerList(context: context),
                child: Text(LocaleKeys.home_search_search_ok_btn.tr),
              )
            ],
          ),
        ),
        icon: const Icon(Icons.manage_search),
      );
}
