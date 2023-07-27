import 'package:get/get.dart';

class CategoryListViewModel {
  final int id;
  final List category;

  CategoryListViewModel({
    required this.id,
    required this.category,
  });

  factory CategoryListViewModel.fromJson(final Map<String, dynamic> json) {
    return CategoryListViewModel(
      id: json['id'],
      category: json['category'],
    );
  }
}
