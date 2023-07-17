import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/vendor_home_page_flower_controller.dart';
import '../../loading_widget.dart';
import 'widget/flower_list.dart';

class HomeScreen extends GetView<VendorHomePageFlowerController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.getFlowerList,
      child:const Stack(
        children: <Widget>[
          FlowerList(),
          Center(
            child: LoadingWidget(),
          ),
        ],
      ),

      /*const FlowerList()*/
    );
  }
}
