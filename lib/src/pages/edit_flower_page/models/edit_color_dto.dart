class EditColorDto {
  final int color, id;

  EditColorDto({
    required this.id,
    required this.color,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'color': color,
      };
}
