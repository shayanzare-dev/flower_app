import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../view/widget/bottom_navigation_bar.dart';

class VendorHomePageFlowerController extends GetxController{
  final selectedIndex = RxInt(0);

  static List<Widget> widgetOptions = <Widget>[
    HomeScreen(),
    AddScreen(),
    SearchScreen(),
    ProfileScreen(),

  ];

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }



}