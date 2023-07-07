import 'package:flower_app/src/pages/vendor_home_page/models/user_view_model.dart';
import 'package:get/get.dart';

import '../../shared/user_type_enum.dart';

class AddFlowerDto {
  final int price, countInStock;
  final String name, image, shortDescription, color;
  final RxList<String> category;
  final UserViewModel vendorUser;
  UserViewModel? customerUser;

  AddFlowerDto(
      {required this.price,
      required this.countInStock,
      required this.name,
      required this.image,
      required this.shortDescription,
      required this.color,
      required this.category,
      required this.vendorUser,
      this.customerUser});

  Map<String, dynamic> toJson() => {
        'name': name,
        'price': price,
        'countInStock': countInStock,
        'image': image,
        'shortDescription': shortDescription,
        'color': color,
        'category': category,
        'vendorUser': {
          "firstName": vendorUser.firstName,
          "lastName": vendorUser.lastName,
          "email": vendorUser.email,
          "passWord": vendorUser.passWord,
          "userType": vendorUser.userType.value,
          "image": vendorUser.image,
          "id": vendorUser.id
        },
        'customerUser': {},
      };
}
