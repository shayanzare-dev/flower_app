import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/customer_home_page_flower_controller.dart';
import '../../models/bought_flowers_view_model.dart';
import '../../models/flower_list_view_model.dart';


class DeleteAlertDialog extends GetView<CustomerHomePageFlowerController> {
  final FlowerListViewModel flowerItem;
  final BoughtFlowers boughtFlowers;
  const DeleteAlertDialog({required this.boughtFlowers ,required this.flowerItem, super.key});

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: () => showDialog<String>(
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
                onPressed: () => controller.alertDialogSelect(
                    context: context, itemSelect: 2, flowerItem: flowerItem, boughtFlowers: boughtFlowers),
                child: const Text('OK'),
              )
            ],
          ),
        ),
        child: const Text('delete'),
      );
}
