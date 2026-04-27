/// Helper function to safely convert dynamic to int
int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is double) return value.toInt();
  return 0;
}

/// Helper function to safely convert dynamic to double
double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

/// Analytics Overview Model
class AnalyticsOverviewModel {
  final int totalAds;
  final int activeAds;
  final int totalViews;
  final int totalFavorites;
  final int totalPosts;
  final int totalLikes;
  final double walletBalance;
  final int walletPoints;

  AnalyticsOverviewModel({
    required this.totalAds,
    required this.activeAds,
    required this.totalViews,
    required this.totalFavorites,
    required this.totalPosts,
    required this.totalLikes,
    required this.walletBalance,
    required this.walletPoints,
  });

  factory AnalyticsOverviewModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsOverviewModel(
      totalAds: _toInt(json['total_ads']),
      activeAds: _toInt(json['active_ads']),
      totalViews: _toInt(json['total_views']),
      totalFavorites: _toInt(json['total_favorites']),
      totalPosts: _toInt(json['total_posts']),
      totalLikes: _toInt(json['total_likes']),
      walletBalance: _toDouble(json['wallet_balance']),
      walletPoints: _toInt(json['wallet_points']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_ads': totalAds,
      'active_ads': activeAds,
      'total_views': totalViews,
      'total_favorites': totalFavorites,
      'total_posts': totalPosts,
      'total_likes': totalLikes,
      'wallet_balance': walletBalance,
      'wallet_points': walletPoints,
    };
  }
}

/// Ad Analytics Model
class AdAnalyticsModel {
  final int id;
  final String title;
  final int viewsCount;
  final int favoritesCount;
  final DateTime createdAt;

  AdAnalyticsModel({
    required this.id,
    required this.title,
    required this.viewsCount,
    required this.favoritesCount,
    required this.createdAt,
  });

  factory AdAnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AdAnalyticsModel(
      id: _toInt(json['id']),
      title: json['title']?.toString() ?? '',
      viewsCount: _toInt(json['views_count']),
      favoritesCount: _toInt(json['favorites_count']),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'views_count': viewsCount,
      'favorites_count': favoritesCount,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Chart Data Model
class ChartDataModel {
  final List<String> labels;
  final List<int> views;
  final List<int> favorites;
  final List<int> posts;

  ChartDataModel({
    required this.labels,
    required this.views,
    required this.favorites,
    required this.posts,
  });

  factory ChartDataModel.fromJson(Map<String, dynamic> json) {
    return ChartDataModel(
      labels: json['labels'] != null
          ? List<String>.from(json['labels'].map((e) => e.toString()))
          : [],
      views: json['views'] != null
          ? List<int>.from(json['views'].map((e) => _toInt(e)))
          : [],
      favorites: json['favorites'] != null
          ? List<int>.from(json['favorites'].map((e) => _toInt(e)))
          : [],
      posts: json['posts'] != null
          ? List<int>.from(json['posts'].map((e) => _toInt(e)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'labels': labels,
      'views': views,
      'favorites': favorites,
      'posts': posts,
    };
  }

  // Helper: Get max value for chart scaling
  int get maxValue {
    final allValues = [...views, ...favorites, ...posts];
    return allValues.isEmpty ? 100 : allValues.reduce((a, b) => a > b ? a : b);
  }
}
