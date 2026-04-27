class Advertise {
  int id;
  String title;
  String description;
  String? notes;
  String price;
  int traderId;
  DateTime createdAt;
  DateTime updatedAt;
  List<AdvertiseImage> images;

  Advertise({
    required this.id,
    required this.title,
    required this.description,
    required this.notes,
    required this.price,
    required this.traderId,
    required this.createdAt,
    required this.updatedAt,
    required this.images,
  });

  // Factory constructor to create an instance from JSON
  factory Advertise.fromJson(Map<String, dynamic> json) {
    return Advertise(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      notes: json['notes'],
      price: json['price'],
      traderId: json['trader_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      images: (json['image'] as List)
          .map((imageJson) => AdvertiseImage.fromJson(imageJson))
          .toList(),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'notes': notes,
      'price': price,
      'trader_id': traderId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'image': images.map((image) => image.toJson()).toList(),
    };
  }
}

class AdvertiseImage {
  int id;
  String url;
  int relatedId;
  String relatedType;
  DateTime createdAt;
  DateTime updatedAt;

  AdvertiseImage({
    required this.id,
    required this.url,
    required this.relatedId,
    required this.relatedType,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create an instance from JSON
  factory AdvertiseImage.fromJson(Map<String, dynamic> json) {
    return AdvertiseImage(
      id: json['id'],
      url: json['url'],
      relatedId: json['related_id'],
      relatedType: json['related_type'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'related_id': relatedId,
      'related_type': relatedType,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
