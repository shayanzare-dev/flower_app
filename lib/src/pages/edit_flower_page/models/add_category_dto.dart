import 'package:get/get.dart';

class AddCategoryDto {
  final RxList<String> category;

  AddCategoryDto({required this.category});

  Map<String, dynamic> toJson() => {
        'category': category,
      };
}
