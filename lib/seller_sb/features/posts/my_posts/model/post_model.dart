
import '../../../../../uses_app_sb/core/shared/models/image_model.dart';

class Post {
  int id;
  final String title;
  int likesCount;
  int disLikesCount;
  final DateTime updatedAt;
  final List<ImageModel> imageUrls;
  bool isLiked;
  bool isDisliked;

  Post({
    required this.title,
    required this.id,
    required this.updatedAt,
    required this.imageUrls,
    required this.likesCount,
    required this.disLikesCount,
    this.isLiked = false,
    this.isDisliked = false,
  });

  // Factory constructor to create a Post object from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      updatedAt: DateTime.parse(
          json['updated_at'] ?? DateTime.now().toIso8601String()),
      imageUrls: (json['image'] as List<dynamic>)
          .map((imgJson) => ImageModel.fromJson(imgJson))
          .toList(),
      likesCount: json['likes_count'] ?? 0,
      disLikesCount: json['dislikes_count'] ?? 0,
      isLiked: json['likes'] != null &&
          (json['likes'] as List)
              .isNotEmpty, // If there are likes, assume post is liked
      isDisliked:
          false, // This would need to be handled based on how dislikes are tracked
    );
  }

  // Method to convert the Post object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'updated_at': updatedAt.toIso8601String(),
      'image': imageUrls.map((image) => image.toJson()).toList(),
      'likes_count': likesCount,
      'dislikes_count': disLikesCount,
      'isLiked': isLiked,
      'isDisliked': isDisliked,
    };
  }
}
