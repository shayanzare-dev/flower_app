import 'bought_flowers_view_model.dart';
import 'user_view_model.dart';

class CartOrder {
  final UserViewModel user;
  final String dateTime;
  int totalPrice;
  int? id;
  final List<BoughtFlowers> boughtFlowers;

  CartOrder({
    this.id,
    required this.user,
    required this.dateTime,
    required this.totalPrice,
    required this.boughtFlowers,
  });

  CartOrder copyWith({
    int? id,
    UserViewModel? user,
    String? dateTime,
    int? totalPrice,
    List<BoughtFlowers>? boughtFlowers,
  }) {
    return CartOrder(
      id : id ?? this.id,
      user: user ?? this.user,
      dateTime: dateTime ?? this.dateTime,
      totalPrice: totalPrice ?? this.totalPrice,
      boughtFlowers: boughtFlowers ?? this.boughtFlowers,
    );
  }

  factory CartOrder.fromJson(Map<String, dynamic> json) {
    List<dynamic> boughtFlowersJson = json['boughtFlowers'];
    List<BoughtFlowers> boughtFlowers =
        boughtFlowersJson.map((e) => BoughtFlowers.fromJson(e)).toList();

    return CartOrder(
      user: UserViewModel.fromJson(json['user']),
      dateTime: json['dateTime'],
      totalPrice: json['totalPrice'],
      id: json['id'],
      boughtFlowers: boughtFlowers,
    );
  }
}
