import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/customer_home_page_flower_controller.dart';
import '../../loading_widget.dart';
import 'widget/customer_flower_list.dart';

class CustomerHomeScreen extends GetView<CustomerHomePageFlowerController> {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: const Stack(
        children: <Widget>[
          CustomerFlowerList(),
          Center(
            child: LoadingWidget(),
          ),
        ],
      ),
    );
  }
}
