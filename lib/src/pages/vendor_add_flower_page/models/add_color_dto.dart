class AddColorDto {
  final int color;

  AddColorDto({required this.color});


  Map<String, dynamic> toJson() => {
    'color': color,
  };
}