import 'bought_flowers_view_model.dart';
import 'user_view_model.dart';

class CartOrderViewModel {
  final UserViewModel user;
  final String dateTime;
  int totalPrice;
  int id;
  final List<BoughtFlowersViewModel> boughtFlowers;

  CartOrderViewModel({
    required this.id,
    required this.user,
    required this.dateTime,
    required this.totalPrice,
    required this.boughtFlowers,
  });

  CartOrderViewModel copyWith({
    int? id,
    UserViewModel? user,
    String? dateTime,
    int? totalPrice,
    List<BoughtFlowersViewModel>? boughtFlowers,
  }) {
    return CartOrderViewModel(
      id : id ?? this.id,
      user: user ?? this.user,
      dateTime: dateTime ?? this.dateTime,
      totalPrice: totalPrice ?? this.totalPrice,
      boughtFlowers: boughtFlowers ?? this.boughtFlowers,
    );
  }

  factory CartOrderViewModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> boughtFlowersJson = json['boughtFlowers'];
    List<BoughtFlowersViewModel> boughtFlowers =
        boughtFlowersJson.map((e) => BoughtFlowersViewModel.fromJson(e)).toList();
    return CartOrderViewModel(
      user: UserViewModel.fromJson(json['user']),
      dateTime: json['dateTime'],
      totalPrice: json['totalPrice'],
      id: json['id'],
      boughtFlowers: boughtFlowers,
    );
  }
}
