class Owner {
  int id;
  String ownerContactNumber;
  String whatsappNumber;
  String telegramNumber;
  String socialMediaLink;
  Store store;

  Owner({
    required this.id,
    required this.ownerContactNumber,
    required this.whatsappNumber,
    required this.telegramNumber,
    required this.socialMediaLink,
    required this.store,
  });

  // Factory constructor to create an Owner object from JSON
  factory Owner.fromJson(Map<String, dynamic> json) {
    return Owner(
      id: json['id'] ?? 0,
      ownerContactNumber: json['owner_contact_number'] ?? '',
      whatsappNumber: json['whatsapp_number'] ?? '',
      telegramNumber: json['telegram_number'] ?? '',
      socialMediaLink: json['social_media_link'] ?? '',
      store: Store.fromJson(json['store'] ?? {}),
    );
  }

  // Method to convert the Owner object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'owner_contact_number': ownerContactNumber,
      'whatsapp_number': whatsappNumber,
      'telegram_number': telegramNumber,
      'social_media_link': socialMediaLink,
      'store': store.toJson(),
    };
  }
}

class Store {
  int id;
  String storeName;
  String? image; // Can be nullable since 'image' can be null in the JSON
  String storeOwnerName;
  String storeNumber;
  int categoryId;
  DateTime createdAt;
  DateTime updatedAt;
  String? city; // City name (optional)
  bool? isFavorite; // Is favorite flag (optional)
  int? storeRate; // Store rating (optional)

  Store({
    required this.id,
    required this.storeName,
    this.image,
    required this.storeOwnerName,
    required this.storeNumber,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    this.city,
    this.isFavorite,
    this.storeRate,
  });

  // Factory constructor to create a Store object from JSON
  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] ?? 0,
      storeName: json['store_name'] ?? '',
      image: json['image'], // Nullable field
      storeOwnerName: json['store_owner_name'] ?? '',
      storeNumber: json['store_number'] ?? '',
      categoryId: json['category_id'] ?? 0,
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
      city: json['city'],
      isFavorite: json['is_favorite'],
      storeRate: json['store_rate'],
    );
  }

  // Method to convert the Store object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_name': storeName,
      'image': image,
      'store_owner_name': storeOwnerName,
      'store_number': storeNumber,
      'category_id': categoryId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'city': city,
      'is_favorite': isFavorite,
      'store_rate': storeRate,
    };
  }
}
