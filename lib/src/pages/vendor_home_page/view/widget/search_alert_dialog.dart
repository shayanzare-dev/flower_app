import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/vendor_home_page_flower_controller.dart';
import '../../models/flower_list_view_model.dart';


class SearchAlertDialog extends GetView<VendorHomePageFlowerController> {


  const SearchAlertDialog({ super.key});

  @override
  Widget build(BuildContext context) => IconButton(
    onPressed: () => showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('your deleted item'),
        content: const Text('are you sure you want to delete?'),
        actions: <Widget>[
         /* TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => controller.alertDialogSelect(
                context: context, itemSelect: 2, flowerItem: flowerItem),
            child: const Text('OK'),
          )*/
        ],
      ),
    ),
    icon: Icon(Icons.search),
  );
}
