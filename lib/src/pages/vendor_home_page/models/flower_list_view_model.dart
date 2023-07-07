import 'package:flower_app/src/pages/vendor_home_page/models/user_view_model.dart';
import 'package:get/get.dart';

import '../../shared/user_type_enum.dart';

class FlowerListViewModel {
  final int id, price, countInStock;
  final String name, image, shortDescription, color;
  final List category;
  final UserViewModel vendorUser;
  UserViewModel? customerUser;

  FlowerListViewModel({
    required this.id,
    required this.price,
    required this.countInStock,
    required this.name,
    required this.image,
    required this.shortDescription,
    required this.color,
    required this.category,
    required this.vendorUser,
  });

  factory FlowerListViewModel.fromJson(final Map<String, dynamic> json) {
    return FlowerListViewModel(
      id: json['id'],
      image: json['image'],
      color: json['color'],
      name: json['name'],
      price: json['price'],
      category: json['category'],
      countInStock: json['countInStock'],
      shortDescription: json['shortDescription'],
      vendorUser: UserViewModel.fromJson(json['vendorUser']),

    );
  }
}
