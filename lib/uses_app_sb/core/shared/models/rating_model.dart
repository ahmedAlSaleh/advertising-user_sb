/// User Info for Rating - simplified user model
class RatingUserInfo {
  final String name;
  final String? image;

  RatingUserInfo({
    required this.name,
    this.image,
  });

  factory RatingUserInfo.fromJson(Map<String, dynamic> json) {
    return RatingUserInfo(
      name: json['name'] ?? 'مستخدم',
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (image != null) 'image': image,
    };
  }
}

/// Rating Model - represents a single rating
class RatingModel {
  final int id;
  final int rate;
  final String? comment;
  final RatingUserInfo user;
  final DateTime createdAt;

  RatingModel({
    required this.id,
    required this.rate,
    this.comment,
    required this.user,
    required this.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'] ?? 0,
      rate: json['rate'] ?? 0,
      comment: json['comment'],
      user: RatingUserInfo.fromJson(json['user'] ?? {}),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rate': rate,
      'comment': comment,
      'user': user.toJson(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Store Ratings Model - represents store ratings summary
class StoreRatingsModel {
  final double averageRating;
  final int totalRatings;
  final List<RatingModel> ratings;

  StoreRatingsModel({
    required this.averageRating,
    required this.totalRatings,
    required this.ratings,
  });

  factory StoreRatingsModel.fromJson(Map<String, dynamic> json) {
    return StoreRatingsModel(
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      totalRatings: json['total_ratings'] ?? 0,
      ratings: json['ratings'] != null
          ? List<RatingModel>.from(
              json['ratings'].map((x) => RatingModel.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average_rating': averageRating,
      'total_ratings': totalRatings,
      'ratings': ratings.map((x) => x.toJson()).toList(),
    };
  }
}

/// Rating Request Model - for submitting a rating
class RatingRequest {
  final int ratedId;
  final String ratedType;
  final int rate;
  final String? comment;

  RatingRequest({
    required this.ratedId,
    required this.ratedType,
    required this.rate,
    this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      'rated_id': ratedId,
      'rated_type': ratedType,
      'rate': rate,
      if (comment != null && comment!.isNotEmpty) 'comment': comment,
    };
  }
}
