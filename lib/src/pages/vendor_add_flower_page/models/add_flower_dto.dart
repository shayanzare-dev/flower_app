import 'package:flower_app/src/pages/vendor_home_page/models/vendor_view_model.dart';
import 'package:get/get.dart';


class AddFlowerDto {
  final int price, countInStock,color;
  final String name, image, shortDescription;
  final RxList<String> category;
  final VendorViewModel vendorUser;


  AddFlowerDto(
      {required this.price,
      required this.countInStock,
      required this.name,
      required this.image,
      required this.shortDescription,
      required this.color,
      required this.category,
      required this.vendorUser,
      });

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
      };

}
