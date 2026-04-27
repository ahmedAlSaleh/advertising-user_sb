// Advertisement Model
class AdvertisementModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final String type; // normal, special
  final String featureType; // none, featured, premium
  final bool isActive;
  final int viewsCount;
  final String? scheduledFor;
  final String? expiresAt;
  final String? promotedUntil;
  final TraderInfo? trader;
  final CategoryInfo? category;
  final CategoryInfo? subCategory;
  final List<String> images;

  AdvertisementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.type,
    this.featureType = 'none',
    this.isActive = true,
    this.viewsCount = 0,
    this.scheduledFor,
    this.expiresAt,
    this.promotedUntil,
    this.trader,
    this.category,
    this.subCategory,
    this.images = const [],
  });

  factory AdvertisementModel.fromJson(Map<String, dynamic> json) {
    return AdvertisementModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      type: json['type'] ?? 'normal',
      featureType: json['feature_type'] ?? 'none',
      isActive: json['is_active'] ?? true,
      viewsCount: json['views_count'] ?? 0,
      scheduledFor: json['scheduled_for'],
      expiresAt: json['expires_at'],
      promotedUntil: json['promoted_until'],
      trader: json['trader'] != null ? TraderInfo.fromJson(json['trader']) : null,
      category: json['category'] != null ? CategoryInfo.fromJson(json['category']) : null,
      subCategory: json['sub_category'] != null ? CategoryInfo.fromJson(json['sub_category']) : null,
      images: json['images'] != null
          ? List<String>.from(json['images'].map((x) => x.toString()))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'type': type,
      'feature_type': featureType,
      'is_active': isActive,
      'views_count': viewsCount,
      'scheduled_for': scheduledFor,
      'expires_at': expiresAt,
      'promoted_until': promotedUntil,
      'trader': trader?.toJson(),
      'category': category?.toJson(),
      'sub_category': subCategory?.toJson(),
      'images': images,
    };
  }

  // Helper getters
  bool get isFeatured => featureType == 'featured' || featureType == 'premium';
  bool get isPremium => featureType == 'premium';
  bool get isScheduled => scheduledFor != null;
  bool get isExpired => expiresAt != null && DateTime.parse(expiresAt!).isBefore(DateTime.now());
  bool get isPromoted {
    if (promotedUntil == null) return false;
    try {
      return DateTime.parse(promotedUntil!).isAfter(DateTime.now());
    } catch (e) {
      return false;
    }
  }

  @override
  String toString() {
    return 'AdvertisementModel(id: $id, title: $title, price: $price, featureType: $featureType, isActive: $isActive)';
  }
}

// Trader Info
class TraderInfo {
  final int id;
  final String city;
  final StoreInfo? store;

  TraderInfo({
    required this.id,
    required this.city,
    this.store,
  });

  factory TraderInfo.fromJson(Map<String, dynamic> json) {
    return TraderInfo(
      id: json['id'] ?? 0,
      city: json['city'] ?? '',
      store: json['store'] != null ? StoreInfo.fromJson(json['store']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city': city,
      'store': store?.toJson(),
    };
  }
}

// Store Info
class StoreInfo {
  final String storeName;

  StoreInfo({required this.storeName});

  factory StoreInfo.fromJson(Map<String, dynamic> json) {
    return StoreInfo(
      storeName: json['store_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_name': storeName,
    };
  }
}

// Category Info
class CategoryInfo {
  final int id;
  final String name;

  CategoryInfo({
    required this.id,
    required this.name,
  });

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(
      id: json['id'] ?? 0,
      name: json['name'] ?? json['name_ar'] ?? json['name_en'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

// Paginated Ads Response
class PaginatedAdsResponse {
  final int currentPage;
  final List<AdvertisementModel> data;
  final int perPage;
  final int total;

  PaginatedAdsResponse({
    required this.currentPage,
    required this.data,
    required this.perPage,
    required this.total,
  });

  factory PaginatedAdsResponse.fromJson(Map<String, dynamic> json) {
    return PaginatedAdsResponse(
      currentPage: json['current_page'] ?? 1,
      data: json['data'] != null
          ? List<AdvertisementModel>.from(
              json['data'].map((x) => AdvertisementModel.fromJson(x)))
          : [],
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
    );
  }

  bool get hasMore => currentPage * perPage < total;
  int get totalPages => (total / perPage).ceil();

  @override
  String toString() {
    return 'PaginatedAdsResponse(page: $currentPage/$totalPages, items: ${data.length}, total: $total)';
  }
}

// Advertisement Filter
class AdvertisementFilter {
  final int? categoryId;
  final int? subCategoryId;
  final String? city;
  final double? minPrice;
  final double? maxPrice;
  final String? type;
  final int page;
  final int perPage;

  AdvertisementFilter({
    this.categoryId,
    this.subCategoryId,
    this.city,
    this.minPrice,
    this.maxPrice,
    this.type,
    this.page = 1,
    this.perPage = 15,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'page': page,
      'per_page': perPage,
    };

    if (categoryId != null) data['category_id'] = categoryId;
    if (subCategoryId != null) data['sub_category_id'] = subCategoryId;
    if (city != null && city!.isNotEmpty) data['city'] = city;
    if (minPrice != null) data['min_price'] = minPrice;
    if (maxPrice != null) data['max_price'] = maxPrice;
    if (type != null && type!.isNotEmpty) data['type'] = type;

    return data;
  }

  AdvertisementFilter copyWith({
    int? categoryId,
    int? subCategoryId,
    String? city,
    double? minPrice,
    double? maxPrice,
    String? type,
    int? page,
    int? perPage,
  }) {
    return AdvertisementFilter(
      categoryId: categoryId ?? this.categoryId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      city: city ?? this.city,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      type: type ?? this.type,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }
}
