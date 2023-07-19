import 'package:flower_app/src/pages/vendor_home_page/view/widget/bottom_navigation_bar_pages/bottom_navigation_bar_search_screen/widget/range_slider_price.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../../../generated/locales.g.dart';
import '../../../../../controller/vendor_home_page_flower_controller.dart';
import 'check_box_color_filter.dart';
import 'dropdown_button.dart';

class SearchAlertDialog extends GetView<VendorHomePageFlowerController> {
  const SearchAlertDialog({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title:  Text(LocaleKeys.home_search_search_filter.tr),
            content:   SizedBox(
              height: 380,
              width: 220,
              child: Column(
                children: [
                  MyDropdownButton(),
                  SizedBox(height: 8),
                  Text(LocaleKeys.home_search_search_color.tr,
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff04927c),
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  CheckBoxColorFilter(),
                  SizedBox(height: 8),
                  Text(LocaleKeys.home_search_search_price.tr,
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0xff04927c),
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  VendorRangeSliderPrice(),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => controller.clearSearchFilterFlowers(context: context),
                child:  Text(LocaleKeys.home_search_search_clear_btn.tr),
              ),

              TextButton(
                onPressed: () => controller.getSearchFilterFlowerList(context: context),
                child:  Text(LocaleKeys.home_search_search_ok_btn.tr),
              )
            ],
          ),
        ),
        icon: const Icon(Icons.manage_search),
      );
}
