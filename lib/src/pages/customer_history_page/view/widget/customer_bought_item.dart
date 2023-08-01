import 'dart:convert';

import 'package:flower_app/src/pages/customer_home_page/models/bought_flowers_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../generated/locales.g.dart';
import '../../controller/customer_history_page_controller.dart';

class CustomerBoughtItem extends GetView<CustomerHistoryPageController> {
  final BoughtFlowersViewModel boughtFlower;

  const CustomerBoughtItem({
    required this.boughtFlower,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
            onTap: () {},
            child: DecoratedBox(
              decoration: _imageFlower(),
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.2, 1.0],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _name(),
                      const SizedBox(height: 8.0),
                      _vendorName(),
                      const SizedBox(height: 8.0),
                      _date(),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _price(),
                          _count(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )),
      );

  Widget _count() {
    return Row(
      children: [
        Text(
          LocaleKeys.customer_home_history_count_bought.tr,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          boughtFlower.buyCount.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _price() {
    return Row(children: [
      Text(
        LocaleKeys.customer_home_history_price.tr,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        ('\$${boughtFlower.sumBuyPrice}'),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ]);
  }

  Widget _date() {
    return Row(
      children: [
        Text(LocaleKeys.customer_home_history_bought_date.tr,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        Text(boughtFlower.dateTime,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
      ],
    );
  }

  Widget _vendorName() {
    return Row(
      children: [
        Text(LocaleKeys.customer_home_history_vendor_name.tr,
            style: const TextStyle(color: Colors.white, fontSize: 20)),
        Text(
          boughtFlower.flowerListViewModel.vendorUser.firstName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
        const SizedBox(width: 5.0),
        Text(
          boughtFlower.flowerListViewModel.vendorUser.lastName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
        ),
      ],
    );
  }

  Widget _name() {
    return Row(
      children: [
        Text(
          LocaleKeys.customer_home_history_flower_name.tr,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          boughtFlower.flowerListViewModel.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  BoxDecoration _imageFlower() {
    return _showImage();
  }

  BoxDecoration _showImage() {
    if (boughtFlower.flowerListViewModel.image == '') {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 6),
            blurRadius: 6.0,
          )
        ],
      );
    }
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16.0),
      boxShadow: const [
        BoxShadow(
          color: Color(0xff04927c),
          offset: Offset(0, 6),
          blurRadius: 6.0,
        )
      ],
      image: DecorationImage(
        image:
        MemoryImage(base64Decode(boughtFlower.flowerListViewModel.image)),
        fit: BoxFit.cover,
      ),
    );
  }

}
