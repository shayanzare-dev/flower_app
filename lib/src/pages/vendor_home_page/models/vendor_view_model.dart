import 'package:flower_app/src/pages/shared/user_type_enum.dart';

class vendorViewModel {
  final int id;
  final String firstName, lastName, email, image,passWord;
  final UserType userType;

  vendorViewModel({
    required this.id,
    required this.passWord,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.image,
    required this.userType,
  });

  factory vendorViewModel.fromJson(final Map<String, dynamic> json) {
    return vendorViewModel(
        passWord: json['passWord'],
        image: json['image'],
        lastName: json['lastName'],
        firstName: json['firstName'],
        userType: UserType.getUserTypeFromValue(json['userType']),
        email: json['email'],
        id: json['id']);
  }
}
