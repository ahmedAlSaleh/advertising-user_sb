
import '../../adverizing/model/advertise_model.dart';

class FavoriteModel {
  final int id;
  final String title;
  final String description;
  final String notes;
  final String price;
  final int traderId;
  List<AdvertiseImage> images;
  FavoriteModel({
    required this.id,
    required this.title,
    required this.description,
    required this.notes,
    required this.images,
    required this.price,
    required this.traderId,
  });

  // Factory method to create a FavoriteModel from JSON
  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      notes: json['notes'],
      price: json['price'],
      traderId: json['trader_id'],
      images: (json['image'] as List)
          .map((imageJson) => AdvertiseImage.fromJson(imageJson))
          .toList(),
    );
  }
}
