import 'flower_list_view_model.dart';
import 'user_view_model.dart';

class BoughtFlowersViewModel {
  final FlowerListViewModel flowerListViewModel;
  int buyCount;
  int sumBuyPrice;
  final String dateTime;
  final UserViewModel user;

  BoughtFlowersViewModel({
    required this.user,
    required this.dateTime,
    required this.flowerListViewModel,
    required this.buyCount,
    required this.sumBuyPrice,
  });

  factory BoughtFlowersViewModel.fromJson(Map<String, dynamic> json) {
    return BoughtFlowersViewModel(
      flowerListViewModel:
          FlowerListViewModel.fromJson(json['flowerListViewModel']),
      buyCount: json['buyCount'],
      sumBuyPrice: json['sumBuyPrice'],
      dateTime: json['dateTime'],
      user: UserViewModel.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flowerListViewModel': flowerListViewModel.toJson(),
      'buyCount': buyCount,
      'sumBuyPrice': sumBuyPrice,
      'dateTime': dateTime,
      'user': user.toJson(),
    };
  }
}
