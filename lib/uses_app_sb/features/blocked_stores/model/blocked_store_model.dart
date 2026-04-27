class BlockedStore {
  int id;
  String storeName;
  String? image;
  String storeOwnerName;
  String storeNumber;
  DateTime createdAt;
  DateTime updatedAt;
  bool isFavorite;
  String city;
  List<Trader> traders;
  List<SubCategory> subCategories;

  BlockedStore({
    required this.id,
    required this.storeName,
    this.image,
    required this.storeOwnerName,
    required this.storeNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.isFavorite,
    required this.city,
    required this.traders,
    required this.subCategories,
  });

  factory BlockedStore.fromJson(Map<String, dynamic> json) {
    return BlockedStore(
      id: json['id'] ?? 0,
      storeName: json['store_name'] ?? '',
      image: json['image'],
      storeOwnerName: json['store_owner_name'] ?? '',
      storeNumber: json['store_number'] ?? '',
      createdAt: DateTime.parse(
          json['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
      isFavorite: json['is_favorite'] ?? false,
      city: json['city'] ?? '',
      traders: json['traders'] != null
          ? List<Trader>.from(
              json['traders'].map((x) => Trader.fromJson(x)))
          : [],
      subCategories: json['sub_categories'] != null
          ? List<SubCategory>.from(
              json['sub_categories'].map((x) => SubCategory.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_name': storeName,
      'image': image,
      'store_owner_name': storeOwnerName,
      'store_number': storeNumber,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_favorite': isFavorite,
      'city': city,
      'traders': List<dynamic>.from(traders.map((x) => x.toJson())),
      'sub_categories':
          List<dynamic>.from(subCategories.map((x) => x.toJson())),
    };
  }
}

class SubCategory {
  int id;
  String name;
  dynamic image;

  SubCategory({
    required this.id,
    required this.name,
    required this.image,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        id: json["id"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
      };
}

class Trader {
  int id;
  String city;
  String ownerContactNumber;
  String? whatsappNumber;
  String? telegramNumber;
  dynamic socialMediaLink;
  int storeId;
  DateTime createdAt;
  DateTime updatedAt;

  Trader({
    required this.id,
    required this.city,
    required this.ownerContactNumber,
    this.whatsappNumber,
    this.telegramNumber,
    required this.socialMediaLink,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Trader.fromJson(Map<String, dynamic> json) => Trader(
        id: json["id"],
        city: json["city"],
        ownerContactNumber: json["owner_contact_number"],
        whatsappNumber: json["whatsapp_number"],
        telegramNumber: json["telegram_number"],
        socialMediaLink: json["social_media_link"],
        storeId: json["store_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "city": city,
        "owner_contact_number": ownerContactNumber,
        "whatsapp_number": whatsappNumber,
        "telegram_number": telegramNumber,
        "social_media_link": socialMediaLink,
        "store_id": storeId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
