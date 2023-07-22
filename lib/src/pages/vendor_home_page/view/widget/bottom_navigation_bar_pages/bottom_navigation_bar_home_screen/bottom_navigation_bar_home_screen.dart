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
      child:  Stack(
        children: <Widget>[
        /*  Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 100),
                child: Text('Flower List is empty',
                    style: TextStyle(
                        fontSize: 20,
                        color: controller.flowerList.isEmpty ? Color(0xff04927c) : Colors.white ,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ) ,*/
          FlowerList(),
          Center(
            child: LoadingWidget(),
          ),
        ],
      ),
    );
  }
}
