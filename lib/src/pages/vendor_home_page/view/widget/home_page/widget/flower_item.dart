import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../../../generated/locales.g.dart';
import '../../../../controller/vendor_home_page_flower_controller.dart';
import '../../../../models/flower_list_view_model.dart';
import 'delete_alert_dialog.dart';
import 'flower_chip_list.dart';

class FlowerItem extends GetView<VendorHomePageFlowerController> {
  final FlowerListViewModel flowerItem;

  const FlowerItem({
    required this.flowerItem,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
            onTap: () {
              controller.goToEditFlowerPage(flowerItem: flowerItem);
            },
            child: DecoratedBox(
              decoration: _imageFlower(),
              child: Container(
                height: 350,
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
                      _flowerName(),
                      const SizedBox(height: 8.0),
                      _flowerDescription(),
                      const SizedBox(height: 8.0),
                      _colorAndDeleteButton(),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _flowerPrice(),
                          _flowerCount(),
                        ],
                      ),
                      Row(
                        children: [
                          FlowerChipList(flowerItem: flowerItem),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )),
      );

  Widget _flowerCount() {
    return Row(
      children: [
        Obx(
          () => controller.isLoadingCountMinus[flowerItem.id]!.value
              ? const CircularProgressIndicator()
              : IconButton(
                  onPressed: () {
                    controller.editCountFlowerMinus(
                      flowerItem: flowerItem,
                    );
                  },
                  icon: const Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                ),
        ),
        Text(
          LocaleKeys.vendor_home_item_count.tr,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          flowerItem.countInStock.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Obx(
          () => controller.isLoadingCountPlus[flowerItem.id]!.value
              ? const CircularProgressIndicator()
              : IconButton(
                  onPressed: () {
                    controller.editCountFlowerPlus(
                      flowerItem: flowerItem,
                    );
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _flowerPrice() {
    return Row(children: [
      Text(
        LocaleKeys.vendor_home_item_price.tr,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      Text(
        ('\$${controller.priceFormat(price: flowerItem.price.toString())}'),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ]);
  }

  Widget _colorAndDeleteButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(LocaleKeys.vendor_home_item_color.tr,
                style: const TextStyle(color: Colors.white, fontSize: 16)),
            Container(
              decoration: BoxDecoration(
                color: Color(flowerItem.color),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            ),
          ],
        ),
        Row(
          children: [
            Obx(
              () => _deleteAlertDialog(flowerItem: flowerItem),
            ),
          ],
        ),
      ],
    );
  }

  Widget _flowerDescription() {
    return Row(
      children: [
        Text(LocaleKeys.vendor_home_item_description.tr,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        Expanded(
          child: Text(
            flowerItem.shortDescription,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _flowerName() {
    return Row(
      children: [
        Text(
          LocaleKeys.vendor_home_item_name.tr,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Expanded(
          child: Text(
            flowerItem.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  BoxDecoration _imageFlower() {
    return _showImage();
  }

  BoxDecoration _showImage(){
    if(flowerItem.image == ''){
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
        image: MemoryImage(base64Decode(flowerItem.image)),
        fit: BoxFit.cover,
      ),
    );
  }



  Widget _deleteAlertDialog({required FlowerListViewModel flowerItem}) {
    if (controller.isLoadingDeleteButton[flowerItem.id]!.value) {
      return const CircularProgressIndicator();
    }
    return DeleteAlertDialog(flowerItem: flowerItem);
  }
}
