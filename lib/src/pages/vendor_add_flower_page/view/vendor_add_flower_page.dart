import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controller/vendor_add_flower_page_controller.dart';
import '../view/widget/flower_chip_list.dart';

class VendorAddFlowerPage extends GetView<VendorAddFlowerPageController> {
  const VendorAddFlowerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Add Flower page'),
          backgroundColor: const Color(0xff04927c)),
      body: Form(
        key: controller.addFlowerFormKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _inputFlowerName(),
              _inputFlowerDescription(),
              _imageFlower(),
              _inputFlowerPrice(),
              _inputFlowerCount(),
              _colorFlower(context),
              const FlowerChipList(),
              _myButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputFlowerName() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: const Color(0xff88d79f),
            borderRadius: BorderRadius.circular(40)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextFormField(
            keyboardType: TextInputType.name,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            controller: controller.flowerNameController,
            decoration: const InputDecoration(
              icon: Icon(Icons.local_florist, color: Colors.white),
              border: InputBorder.none,
              label: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  'Flower name',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            validator: (value) {
              return controller.validateFlowerName(
                value: value!,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _inputFlowerDescription() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: const Color(0xff88d79f),
            borderRadius: BorderRadius.circular(40)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextFormField(
            keyboardType: TextInputType.name,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            controller: controller.flowerDescriptionController,
            decoration: const InputDecoration(
              icon: Icon(Icons.filter_vintage, color: Colors.white),
              border: InputBorder.none,
              label: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  'Flower description',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            validator: (value) {
              return controller.validateFlowerDescription(
                value: value!,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _imageFlower() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Material(
                    color: Colors.lightBlueAccent[100],
                    borderRadius: BorderRadius.circular(40),
                    child: InkWell(
                      onTap: () {
                        controller.getImage(
                          imageSource: ImageSource.gallery,
                        );
                      },
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                          alignment: AlignmentDirectional.center,
                          height: 80,
                          width: 380,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(width: 3, color: Colors.white),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Add Image Flower',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Icon(
                                Icons.image,
                                size: 30,
                                color: Colors.white,
                              ),
                            ],
                          )),
                    ),
                  ),
                  PositionedDirectional(
                    bottom: 20,
                    start: 15,
                    child: Material(
                      color: Colors.lightBlueAccent[100],
                      borderRadius: BorderRadius.circular(100),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(100),
                        onTap: () {
                          controller.getImage(
                            imageSource: ImageSource.camera,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border:
                                  Border.all(width: 4, color: Colors.white)),
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.camera_alt,
                              size: 25, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _colorFlower(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Material(
                    color: Colors.lightBlueAccent[100],
                    borderRadius: BorderRadius.circular(40),
                    child: InkWell(
                      onTap: () {
                        openColorPicker(context);
                      },
                      borderRadius: BorderRadius.circular(40),
                      child: Container(
                          alignment: AlignmentDirectional.center,
                          height: 80,
                          width: 380,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            border: Border.all(width: 3, color: Colors.white),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text('Add Flower color',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Icon(
                                Icons.palette,
                                size: 30,
                                color: Colors.white,
                              ),
                            ],
                          )),
                    ),
                  ),
                  Obx(
                    () => PositionedDirectional(
                      bottom: 20,
                      start: 15,
                      child: Material(
                        color: controller.selectedColor.value,
                        borderRadius: BorderRadius.circular(100),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(100),
                          onTap: () {
                            // controller.getImage(ImageSource.gallery);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border:
                                    Border.all(width: 4, color: Colors.white)),
                            width: 40,
                            height: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _inputFlowerPrice() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: const Color(0xff88d79f),
            borderRadius: BorderRadius.circular(40)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextFormField(
            keyboardType: TextInputType.number,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            controller: controller.flowerPriceController,
            decoration: const InputDecoration(
              icon: Icon(Icons.money_off, color: Colors.white),
              border: InputBorder.none,
              label: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  'Flower Price',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            validator: (value) {
              return controller.validateFlowerPrice(
                value: value!,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _inputFlowerCount() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
            color: const Color(0xff88d79f),
            borderRadius: BorderRadius.circular(40)),
        child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: TextFormField(
            keyboardType: TextInputType.number,
            style: const TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            controller: controller.flowerCountController,
            decoration: const InputDecoration(
              icon: Icon(Icons.onetwothree, color: Colors.white),
              border: InputBorder.none,
              label: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  'Flower Count',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            validator: (value) {
              return controller.validateFlowerCount(
                value: value!,
              );
            },
          ),
        ),
      ),
    );
  }

  void openColorPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: controller.selectedColor.value,
              onColorChanged: (value) {
                controller.changeColor(
                  color: value,
                );
              },
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _myButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              controller.onSubmitAddFlower();
              controller.goToHomeVendorPage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text(
              'Add Flower',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
