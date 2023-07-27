
class ColorListViewModel {
  final int id;
  final int color;

  ColorListViewModel({
    required this.id,
    required this.color,
  });

  factory ColorListViewModel.fromJson(final Map<String, dynamic> json) {
    return ColorListViewModel(
      id: json['id'],
      color: json['color'],
    );
  }
}
