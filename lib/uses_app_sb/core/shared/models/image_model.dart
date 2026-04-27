class ImageModel {
  int id;
  String url;

  ImageModel({
    required this.id,
    required this.url,
  });

  // Factory constructor to create an ImageModel from JSON
  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] ?? 0, // Default value 0 for id
      url: json['url'] ?? '', // Default empty string for url
    );
  }

  // Method to convert the model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
    };
  }
}
