import 'package:flower_app/src/pages/vendor_home_page/models/vendor_view_model.dart';


class EditFlowerDto {
  final int price, countInStock, color, id;
  final String name, image, shortDescription;
  final List category;
  final VendorViewModel vendorUser;


  EditFlowerDto(
      {required this.id,
      required this.price,
      required this.countInStock,
      required this.name,
      required this.image,
      required this.shortDescription,
      required this.color,
      required this.category,
      required this.vendorUser,
      });

  Map<String, dynamic> toJson() => {
        'id': id,
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
