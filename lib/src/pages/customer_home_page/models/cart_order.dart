import 'bought_flowers_view_model.dart';
import 'user_view_model.dart';

class CartOrder {
  final UserViewModel user;
  final String dateTime;
  int totalPrice;
  final List<BoughtFlowers> boughtFlowers;

  CartOrder({
    required this.user,
    required this.dateTime,
    required this.totalPrice,
    required this.boughtFlowers,
  });

  CartOrder copyWith({
    UserViewModel? user,
    String? dateTime,
    int? totalPrice,
    List<BoughtFlowers>? boughtFlowers,
  }) {
    return CartOrder(
      user: user ?? this.user,
      dateTime: dateTime ?? this.dateTime,
      totalPrice: totalPrice ?? this.totalPrice,
      boughtFlowers: boughtFlowers ?? this.boughtFlowers,
    );
  }
}
