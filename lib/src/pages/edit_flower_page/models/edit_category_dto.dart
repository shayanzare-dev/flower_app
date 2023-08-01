

class EditCategoryDto {
  final int id;
  final List category;

  EditCategoryDto({
    required this.id,
    required this.category,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'category': category,
      };
}
