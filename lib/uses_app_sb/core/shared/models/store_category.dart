// To parse this JSON data, do
//
// final storeCategory = storeCategoryFromJson(jsonString);

import 'dart:convert';

StoreCategory storeCategoryFromJson(String str) => StoreCategory.fromJson(json.decode(str));

String storeCategoryToJson(StoreCategory data) => json.encode(data.toJson());

class StoreCategory {
  List<Datum> data;

  StoreCategory({
    required this.data,
  });

  factory StoreCategory.fromJson(Map<String, dynamic> json) => StoreCategory(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  int id;
  String name;
  dynamic image;
  DateTime createdAt;
  DateTime updatedAt;
  List<Datum>? subCategories;
  int? categoryId;

  Datum({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    this.subCategories,
    this.categoryId,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        subCategories: json["sub_categories"] == null
            ? []
            : List<Datum>.from(json["sub_categories"]!.map((x) => Datum.fromJson(x))),
        categoryId: json["category_id"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "sub_categories": subCategories == null
            ? []
            : List<dynamic>.from(subCategories!.map((x) => x.toJson())),
        "category_id": categoryId,
      };
}
