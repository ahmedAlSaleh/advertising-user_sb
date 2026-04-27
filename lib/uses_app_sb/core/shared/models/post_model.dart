/// Helper function to safely convert dynamic to int
int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  if (value is double) return value.toInt();
  return 0;
}

/// Helper function to safely convert dynamic to nullable int
int? _toNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  if (value is double) return value.toInt();
  return null;
}

/// Trader Info for Post
class PostTraderInfo {
  final int? id;
  final PostStoreInfo? store;

  PostTraderInfo({
    this.id,
    this.store,
  });

  factory PostTraderInfo.fromJson(Map<String, dynamic> json) {
    return PostTraderInfo(
      id: _toNullableInt(json['id']),
      store: json['store'] != null
          ? PostStoreInfo.fromJson(json['store'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (store != null) 'store': store!.toJson(),
    };
  }
}

/// Store Info for Post
class PostStoreInfo {
  final String storeName;
  final String? image;

  PostStoreInfo({
    required this.storeName,
    this.image,
  });

  factory PostStoreInfo.fromJson(Map<String, dynamic> json) {
    return PostStoreInfo(
      storeName: json['store_name'] ?? '',
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_name': storeName,
      if (image != null) 'image': image,
    };
  }
}

/// Post Model
class PostModel {
  final int id;
  final String content;
  final PostTraderInfo? trader;
  final int likesCount;
  final int dislikesCount;
  final bool isLiked;
  final bool isDisliked;
  final List<String> images;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.content,
    this.trader,
    this.likesCount = 0,
    this.dislikesCount = 0,
    this.isLiked = false,
    this.isDisliked = false,
    this.images = const [],
    required this.createdAt,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: _toInt(json['id']),
      // API returns 'title' field, not 'content'
      content: json['title']?.toString() ?? json['content']?.toString() ?? '',
      trader: json['trader'] != null
          ? PostTraderInfo.fromJson(json['trader'])
          : null,
      likesCount: _toInt(json['likes_count']),
      dislikesCount: _toInt(json['dislikes_count']),
      isLiked: json['is_liked'] == true || json['is_liked'] == 1 || json['is_liked'] == '1',
      isDisliked: json['is_disliked'] == true || json['is_disliked'] == 1 || json['is_disliked'] == '1',
      // API returns 'image' field, not 'images'
      images: (json['image'] ?? json['images']) != null
          ? List<String>.from((json['image'] ?? json['images']).map((e) => e.toString()))
          : [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      if (trader != null) 'trader': trader!.toJson(),
      'likes_count': likesCount,
      'dislikes_count': dislikesCount,
      'is_liked': isLiked,
      'is_disliked': isDisliked,
      'images': images,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Helper: Get store name
  String get storeName => trader?.store?.storeName ?? 'متجر غير معروف';

  // Helper: Get store image
  String? get storeImage => trader?.store?.image;

  // Copy with
  PostModel copyWith({
    int? id,
    String? content,
    PostTraderInfo? trader,
    int? likesCount,
    int? dislikesCount,
    bool? isLiked,
    bool? isDisliked,
    List<String>? images,
    DateTime? createdAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      content: content ?? this.content,
      trader: trader ?? this.trader,
      likesCount: likesCount ?? this.likesCount,
      dislikesCount: dislikesCount ?? this.dislikesCount,
      isLiked: isLiked ?? this.isLiked,
      isDisliked: isDisliked ?? this.isDisliked,
      images: images ?? this.images,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Paginated Posts Response
class PaginatedPostsResponse {
  final int currentPage;
  final List<PostModel> posts;
  final int perPage;
  final int total;
  final int lastPage;

  PaginatedPostsResponse({
    required this.currentPage,
    required this.posts,
    required this.perPage,
    required this.total,
    required this.lastPage,
  });

  factory PaginatedPostsResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedPostsResponse(
      currentPage: _toInt(json['current_page'] ?? 1),
      posts: json['data'] != null
          ? List<PostModel>.from(
              json['data'].map((x) => PostModel.fromJson(x)),
            )
          : [],
      perPage: _toInt(json['per_page'] ?? 15),
      total: _toInt(json['total']),
      lastPage: _toInt(json['last_page'] ?? 1),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'data': posts.map((x) => x.toJson()).toList(),
      'per_page': perPage,
      'total': total,
      'last_page': lastPage,
    };
  }

  bool get hasMorePages => currentPage < lastPage;
}
