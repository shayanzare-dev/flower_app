import 'package:flower_app/src/pages/vendor_home_page/view/widget/bottom_navigation_bar_pages/bottom_navigation_bar_add_screen/widget/flower_chip_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../../../generated/locales.g.dart';
import '../../../../controller/vendor_home_page_flower_controller.dart';
import '../../loading_widget.dart';

class AddScreen extends GetView<VendorHomePageFlowerController> {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
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
            SizedBox(
              height: 30,
              child: const Stack(
                children: <Widget>[
                  Center(
                    child: LoadingWidget(),
                  ),
                ],
              ),
            )
          ],
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
            decoration:  InputDecoration(
              icon: Icon(Icons.local_florist, color: Colors.white),
              border: InputBorder.none,
              label: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  LocaleKeys.vendor_home_add_flower_name.tr,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            validator: (value) {
              return controller.validateFlowerName( value: value!,);
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
            decoration:  InputDecoration(
              icon: Icon(Icons.filter_vintage, color: Colors.white),
              border: InputBorder.none,
              label: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  LocaleKeys.vendor_home_add_flower_description.tr,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            validator: (value) {
              return controller.validateFlowerDescription( value: value!,);
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
                        controller.getImage( imageSource: ImageSource.gallery,);
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
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(LocaleKeys.vendor_home_add_flower_image.tr,
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
                          controller.getImage( imageSource: ImageSource.camera,);
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
                          child:  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(LocaleKeys.vendor_home_add_flower_color.tr,
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
            decoration:  InputDecoration(
              icon: Icon(Icons.money_off, color: Colors.white),
              border: InputBorder.none,
              label: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  LocaleKeys.vendor_home_add_flower_price.tr,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            validator: (value) {
              return controller.validateFlowerPrice( value: value!,);
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
            decoration:  InputDecoration(
              icon: Icon(Icons.onetwothree, color: Colors.white),
              border: InputBorder.none,
              label: Padding(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  LocaleKeys.vendor_home_add_flower_count.tr,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            validator: (value) {
              return controller.validateFlowerCount( value: value!,);
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
                controller.changeColor( color: value,);
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
            },
            child: Text(
              LocaleKeys.vendor_home_add_flower_add_btn.tr,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

