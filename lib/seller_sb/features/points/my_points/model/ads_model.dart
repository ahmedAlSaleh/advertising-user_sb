class AdModel {
  final String title;
  final String points;
  final String imageUrl;
  final bool isActive;

  AdModel({
    required this.title,
    required this.points,
    required this.imageUrl,
    this.isActive = true,
  });
}
