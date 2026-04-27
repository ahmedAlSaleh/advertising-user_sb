// To parse this JSON data, do
//
// final storeDetailsModel = storeDetailsModelFromJson(jsonString);

import 'dart:convert';

StoreDetailsModel storeDetailsModelFromJson(String str) =>
    StoreDetailsModel.fromJson(json.decode(str));

String storeDetailsModelToJson(StoreDetailsModel data) =>
    json.encode(data.toJson());

class StoreDetailsModel {
  bool status;
  Store store;

  StoreDetailsModel({
    required this.status,
    required this.store,
  });

  factory StoreDetailsModel.fromJson(Map<String, dynamic> json) =>
      StoreDetailsModel(
        status: json["status"],
        store: Store.fromJson(json["store"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "store": store.toJson(),
      };
}

class Store {
  int id;
  String storeName;
  dynamic image;
  String storeOwnerName;
  String storeNumber;
  DateTime createdAt;
  DateTime updatedAt;
  bool isFavourite;
  int? storeRate;
  String city;
  List<SubCategory> subCategories;

  Store({
    required this.id,
    required this.storeName,
    required this.image,
    required this.storeOwnerName,
    required this.storeNumber,
    required this.createdAt,
    required this.updatedAt,
    required this.isFavourite,
    this.storeRate,
    required this.city,
    required this.subCategories,
  });

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        id: json["id"],
        storeName: json["store_name"],
        image: json["image"],
        storeOwnerName: json["store_owner_name"],
        storeNumber: json["store_number"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        isFavourite: json["is_favorite"] ?? false,
        storeRate: json["store_rate"],
        city: json["city"] ?? '',
        subCategories: List<SubCategory>.from(
            json["sub_categories"].map((x) => SubCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "store_name": storeName,
        "image": image,
        "store_owner_name": storeOwnerName,
        "store_number": storeNumber,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "is_favorite": isFavourite,
        "store_rate": storeRate,
        "city": city,
        "sub_categories":
            List<dynamic>.from(subCategories.map((x) => x.toJson())),
      };
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
