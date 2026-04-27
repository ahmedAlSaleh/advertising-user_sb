import 'package:flutter/material.dart';

/// Store Model - للمتاجر
class StoreModel {
  final int id;
  final String storeName;
  final String storeOwnerName;
  final String? image;
  final String? storeNumber;
  final TraderInfo? trader;
  final List<CategoryInfo> categories;
  final int advertisementsCount;
  final int postsCount;
  final double averageRating;
  final int totalReviews;
  final bool isFavorite;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  StoreModel({
    required this.id,
    required this.storeName,
    required this.storeOwnerName,
    this.image,
    this.storeNumber,
    this.trader,
    this.categories = const [],
    this.advertisementsCount = 0,
    this.postsCount = 0,
    this.averageRating = 0.0,
    this.totalReviews = 0,
    this.isFavorite = false,
    this.createdAt,
    this.updatedAt,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'] ?? 0,
      storeName: json['store_name'] ?? '',
      storeOwnerName: json['store_owner_name'] ?? '',
      image: json['image'],
      storeNumber: json['store_number'],
      trader: json['trader'] != null
          ? TraderInfo.fromJson(json['trader'])
          : null,
      categories: json['categories'] != null
          ? List<CategoryInfo>.from(
              json['categories'].map((x) => CategoryInfo.fromJson(x)))
          : [],
      advertisementsCount: json['advertisements_count'] ?? 0,
      postsCount: json['posts_count'] ?? 0,
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      totalReviews: json['total_reviews'] ?? 0,
      isFavorite: json['is_favorite'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_name': storeName,
      'store_owner_name': storeOwnerName,
      'image': image,
      'store_number': storeNumber,
      'trader': trader?.toJson(),
      'categories': categories.map((x) => x.toJson()).toList(),
      'advertisements_count': advertisementsCount,
      'posts_count': postsCount,
      'average_rating': averageRating,
      'total_reviews': totalReviews,
      'is_favorite': isFavorite,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'StoreModel(id: $id, name: $storeName, rating: $averageRating, ads: $advertisementsCount)';
  }
}

/// Trader Info - معلومات التاجر
class TraderInfo {
  final int id;
  final String? city;
  final String? whatsappNumber;
  final String? telegramNumber;
  final String? socialMediaLink;

  TraderInfo({
    required this.id,
    this.city,
    this.whatsappNumber,
    this.telegramNumber,
    this.socialMediaLink,
  });

  factory TraderInfo.fromJson(Map<String, dynamic> json) {
    return TraderInfo(
      id: json['id'] ?? 0,
      city: json['city'],
      whatsappNumber: json['whatsapp_number'],
      telegramNumber: json['telegram_number'],
      socialMediaLink: json['social_media_link'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city': city,
      'whatsapp_number': whatsappNumber,
      'telegram_number': telegramNumber,
      'social_media_link': socialMediaLink,
    };
  }
}

/// Category Info - معلومات التصنيف
class CategoryInfo {
  final int id;
  final String name;
  final String? image;

  CategoryInfo({
    required this.id,
    required this.name,
    this.image,
  });

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}

/// Store Search Filter
class StoreSearchFilter {
  final String? storeName;
  final String? city;
  final int? categoryId;

  StoreSearchFilter({
    this.storeName,
    this.city,
    this.categoryId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    if (storeName != null && storeName!.isNotEmpty) {
      data['store_name'] = storeName;
    }
    if (city != null && city!.isNotEmpty) {
      data['city'] = city;
    }
    if (categoryId != null) {
      data['category_id'] = categoryId;
    }

    return data;
  }
}

/// Store Hours Model - أوقات عمل المتجر
class StoreHoursModel {
  final int? id;
  final String day;
  final String? opensAt;
  final String? closesAt;
  final bool isClosed;

  StoreHoursModel({
    this.id,
    required this.day,
    this.opensAt,
    this.closesAt,
    this.isClosed = false,
  });

  factory StoreHoursModel.fromJson(Map<String, dynamic> json) {
    return StoreHoursModel(
      id: json['id'],
      day: json['day'] ?? '',
      opensAt: json['opens_at'],
      closesAt: json['closes_at'],
      isClosed: json['is_closed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'day': day,
      'opens_at': opensAt,
      'closes_at': closesAt,
      'is_closed': isClosed,
    };
  }

  /// Helper: Get Arabic day name
  String get dayNameAr {
    switch (day.toLowerCase()) {
      case 'sunday':
        return 'الأحد';
      case 'monday':
        return 'الاثنين';
      case 'tuesday':
        return 'الثلاثاء';
      case 'wednesday':
        return 'الأربعاء';
      case 'thursday':
        return 'الخميس';
      case 'friday':
        return 'الجمعة';
      case 'saturday':
        return 'السبت';
      default:
        return day;
    }
  }

  /// Helper: Format time range
  String get formattedHours {
    if (isClosed) {
      return 'مغلق';
    }
    if (opensAt != null && closesAt != null) {
      return '$opensAt - $closesAt';
    }
    return 'غير محدد';
  }

  /// Helper: Check if open now
  bool isOpenNow() {
    if (isClosed || opensAt == null || closesAt == null) {
      return false;
    }

    try {
      final now = DateTime.now();
      final currentDay = _getDayName(now.weekday);

      if (day.toLowerCase() != currentDay.toLowerCase()) {
        return false;
      }

      final openTime = _parseTime(opensAt!);
      final closeTime = _parseTime(closesAt!);
      final currentTime = TimeOfDay.fromDateTime(now);

      return _isTimeBetween(currentTime, openTime, closeTime);
    } catch (e) {
      return false;
    }
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 7:
        return 'Sunday';
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      default:
        return '';
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  bool _isTimeBetween(TimeOfDay current, TimeOfDay start, TimeOfDay end) {
    final currentMinutes = current.hour * 60 + current.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;

    return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
  }

  StoreHoursModel copyWith({
    int? id,
    String? day,
    String? opensAt,
    String? closesAt,
    bool? isClosed,
  }) {
    return StoreHoursModel(
      id: id ?? this.id,
      day: day ?? this.day,
      opensAt: opensAt ?? this.opensAt,
      closesAt: closesAt ?? this.closesAt,
      isClosed: isClosed ?? this.isClosed,
    );
  }

  @override
  String toString() {
    return 'StoreHoursModel(day: $day, hours: $formattedHours)';
  }
}

/// Store Post Model - منشورات المتجر
class StorePostModel {
  final int id;
  final String content;
  final int likesCount;
  final DateTime createdAt;
  final bool isLiked;

  StorePostModel({
    required this.id,
    required this.content,
    this.likesCount = 0,
    required this.createdAt,
    this.isLiked = false,
  });

  factory StorePostModel.fromJson(Map<String, dynamic> json) {
    return StorePostModel(
      id: json['id'] ?? 0,
      content: json['content'] ?? '',
      likesCount: json['likes_count'] ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      isLiked: json['is_liked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'likes_count': likesCount,
      'created_at': createdAt.toIso8601String(),
      'is_liked': isLiked,
    };
  }
}
