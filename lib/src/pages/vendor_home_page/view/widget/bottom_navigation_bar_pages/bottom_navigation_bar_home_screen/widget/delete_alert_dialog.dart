import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controller/vendor_home_page_flower_controller.dart';
import '../../../../../models/flower_list_view_model.dart';


class DeleteAlertDialog extends GetView<VendorHomePageFlowerController> {
  final FlowerListViewModel flowerItem;

  const DeleteAlertDialog({required this.flowerItem, super.key});

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
              onPressed: () => controller.alertDialogSelect(
                  context: context, itemSelect: 2, flowerItem: flowerItem),
              child: const Text('OK'),
            )
          ],
        ),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: Color(0xff54786c),
        borderRadius: BorderRadius.circular(25.0),

      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Text(
          'Delete',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );

/*TextButton(
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
                    context: context, itemSelect: 2, flowerItem: flowerItem),
                child: const Text('OK'),
              )
            ],
          ),
        ),
        child: const Text('delete'),
      );*/
}
