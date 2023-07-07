import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../login_page/controller/login_page_flower_controller.dart';
import '../../controller/vendor_home_page_flower_controller.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'home Screen',
        style: Theme.of(context).textTheme.headline4,
      ),
    );
  }
}