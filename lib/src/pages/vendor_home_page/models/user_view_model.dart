import 'package:flower_app/src/pages/shared/user_type_enum.dart';

class UserViewModel {
  final int id, passWord;
  final String firstName, lastName, email, image;
  final UserType userType;

  UserViewModel({
    required this.id,
    required this.passWord,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.image,
    required this.userType,
  });

  factory UserViewModel.fromJson(final Map<String, dynamic> json) {
    return UserViewModel(
        passWord: json['passWord'],
        image: json['image'],
        lastName: json['lastName'],
        firstName: json['firstName'],
        userType: UserType.getUserTypeFromValue(json['userType']),
        email: json['email'],
        id: json['id']);
  }
}
