// To parse this JSON data, do
//
// final profileData = profileDataFromJson(jsonString);

import 'dart:convert';

ProfileData profileDataFromJson(String str) => ProfileData.fromJson(json.decode(str));

String profileDataToJson(ProfileData data) => json.encode(data.toJson());

class ProfileData {
  bool status;
  Data data;

  ProfileData({
    required this.status,
    required this.data,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        status: json["status"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Data {
  int id;
  String city;
  String ownerContactNumber;
  String? whatsappNumber;
  String? telegramNumber;
  String? socialMediaLink;
  String? storeDescription;
  int storeId;
  DateTime createdAt;
  DateTime updatedAt;
  Store store;
  Wallet? wallet; // ✅ حقل جديد للمحفظة

  Data({
    required this.id,
    required this.city,
    required this.ownerContactNumber,
    this.whatsappNumber,
    this.telegramNumber,
    this.socialMediaLink,
    this.storeDescription,
    required this.storeId,
    required this.createdAt,
    required this.updatedAt,
    required this.store,
    this.wallet, // ✅ حقل جديد
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        city: json["city"],
        ownerContactNumber: json["owner_contact_number"],
        whatsappNumber: json["whatsapp_number"],
        telegramNumber: json["telegram_number"],
        socialMediaLink: json["social_media_link"],
        storeDescription: json["store_description"],
        storeId: json["store_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        store: Store.fromJson(json["store"]),
        wallet: json["wallet"] != null ? Wallet.fromJson(json["wallet"]) : null, // ✅ حقل جديد
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "city": city,
        "owner_contact_number": ownerContactNumber,
        "whatsapp_number": whatsappNumber,
        "telegram_number": telegramNumber,
        "social_media_link": socialMediaLink,
        "store_description": storeDescription,
        "store_id": storeId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "store": store.toJson(),
        "wallet": wallet?.toJson(), // ✅ حقل جديد
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
  List<SubCategory> subCategories;

  Store({
    required this.id,
    required this.storeName,
    required this.image,
    required this.storeOwnerName,
    required this.storeNumber,
    required this.createdAt,
    required this.updatedAt,
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

/// Wallet Model للمحفظة والنقاط
class Wallet {
  final int balance;
  final int points;

  Wallet({
    required this.balance,
    required this.points,
  });

  factory Wallet.fromJson(Map<String, dynamic> json) => Wallet(
        balance: json["balance"] ?? 0,
        points: json["points"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "points": points,
      };
}
