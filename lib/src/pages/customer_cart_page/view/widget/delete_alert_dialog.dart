import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../generated/locales.g.dart';
import '../../../customer_home_page/models/bought_flowers_view_model.dart';
import '../../../customer_home_page/models/flower_list_view_model.dart';
import '../../controller/customer_cart_page_controller.dart';


class DeleteAlertDialog extends GetView<CustomerCartPageController> {
  final FlowerListViewModel flowerItem;
  final BoughtFlowersViewModel boughtFlowers;

  const DeleteAlertDialog(
      {required this.boughtFlowers, required this.flowerItem, super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('your deleted item'),
              content: const Text('are you sure you want to delete?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => controller.deleteAlertDialogSelect(
                      context: context,
                      itemSelect: 2,
                      flowerItem: flowerItem,
                      boughtFlowers: boughtFlowers),
                  child: const Text('OK'),
                )
              ],
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xff54786c),
            borderRadius: BorderRadius.circular(25.0),
          ),
          child:  Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Text(
              LocaleKeys.vendor_home_item_delete_btn.tr,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );

}
