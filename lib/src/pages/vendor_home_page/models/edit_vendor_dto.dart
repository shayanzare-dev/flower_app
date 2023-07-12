import 'package:get/get.dart';

import '../../shared/user_type_enum.dart';
import 'add_flower_dto.dart';
import 'edit_flower_dto.dart';
import 'flower_list_view_model.dart';

class EditVendorDto {
  final int id;
  final UserType userType;
  final String firstName, lastName, email, passWord, image;
  final RxList<FlowerListViewModel> flowerList;

  EditVendorDto({
    required this.id,
    required this.flowerList,
    required this.userType,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.passWord,
    required this.image,
  });

  EditVendorDto copyWith({
    int? id,
    UserType? userType,
    String? firstName,
    String? lastName,
    String? email,
    String? passWord,
    String? image,
    RxList<FlowerListViewModel>? flowerList,
  }) {
    return EditVendorDto(
      id: id ?? this.id,
      userType: userType ?? this.userType,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      passWord: passWord ?? this.passWord,
      image: image ?? this.image,
      flowerList: flowerList ?? this.flowerList,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userType': userType.value,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'passWord': passWord,
        'image': image,
        'flowerList': flowerList.map((flower) => flower.toJson()).toList(),
      };
}
