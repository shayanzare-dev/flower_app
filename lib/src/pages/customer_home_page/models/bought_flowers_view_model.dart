import 'flower_list_view_model.dart';

class BoughtFlowers {
  final FlowerListViewModel flowerListViewModel;
  int buyCount;
  int sumBuyPrice;

  BoughtFlowers({
    required this.flowerListViewModel,
    required this.buyCount,
    required this.sumBuyPrice,
  });

  factory BoughtFlowers.fromJson(Map<String, dynamic> json) {
    return BoughtFlowers(
      flowerListViewModel:
          FlowerListViewModel.fromJson(json['flowerListViewModel']),
      buyCount: json['buyCount'],
      sumBuyPrice: json['sumBuyPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'flowerListViewModel': flowerListViewModel.toJson(),
      'buyCount': buyCount,
      'sumBuyPrice': sumBuyPrice,
    };
  }


}
