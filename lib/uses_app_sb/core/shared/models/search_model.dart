import 'advertisement_model.dart';
import 'post_model.dart';
import 'store_model.dart';

/// Search Result Model - contains all search results
class SearchResultModel {
  final List<AdvertisementModel> advertisements;
  final List<PostModel> posts;
  final List<StoreModel> stores;

  SearchResultModel({
    this.advertisements = const [],
    this.posts = const [],
    this.stores = const [],
  });

  factory SearchResultModel.fromJson(Map<String, dynamic> json) {
    return SearchResultModel(
      advertisements: json['advertisements'] != null
          ? List<AdvertisementModel>.from(
              (json['advertisements'] is List
                      ? json['advertisements']
                      : json['advertisements']['data'] ?? [])
                  .map((x) => AdvertisementModel.fromJson(x)),
            )
          : [],
      posts: json['posts'] != null
          ? List<PostModel>.from(
              (json['posts'] is List ? json['posts'] : json['posts']['data'] ?? [])
                  .map((x) => PostModel.fromJson(x)),
            )
          : [],
      stores: json['stores'] != null
          ? List<StoreModel>.from(
              (json['stores'] is List ? json['stores'] : json['stores']['data'] ?? [])
                  .map((x) => StoreModel.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'advertisements': advertisements.map((x) => x.toJson()).toList(),
      'posts': posts.map((x) => x.toJson()).toList(),
      'stores': stores.map((x) => x.toJson()).toList(),
    };
  }

  // Helper: Check if has results
  bool get hasResults =>
      advertisements.isNotEmpty || posts.isNotEmpty || stores.isNotEmpty;

  // Helper: Total results count
  int get totalResults =>
      advertisements.length + posts.length + stores.length;
}

/// Advanced Search Filter Model
class AdvancedSearchFilter {
  final String? query;
  final int? categoryId;
  final int? subCategoryId;
  final String? city;
  final double? minPrice;
  final double? maxPrice;
  final String? type; // normal, urgent, hot
  final String? featureType; // free, premium, vip
  final String? sortBy; // price, date, views
  final String? sortOrder; // asc, desc
  final int page;
  final int perPage;

  AdvancedSearchFilter({
    this.query,
    this.categoryId,
    this.subCategoryId,
    this.city,
    this.minPrice,
    this.maxPrice,
    this.type,
    this.featureType,
    this.sortBy = 'date',
    this.sortOrder = 'desc',
    this.page = 1,
    this.perPage = 20,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'page': page,
      'per_page': perPage,
    };

    if (query != null && query!.isNotEmpty) data['query'] = query;
    if (categoryId != null) data['category_id'] = categoryId;
    if (subCategoryId != null) data['sub_category_id'] = subCategoryId;
    if (city != null && city!.isNotEmpty) data['city'] = city;
    if (minPrice != null) data['min_price'] = minPrice;
    if (maxPrice != null) data['max_price'] = maxPrice;
    if (type != null && type!.isNotEmpty) data['type'] = type;
    if (featureType != null && featureType!.isNotEmpty) {
      data['feature_type'] = featureType;
    }
    if (sortBy != null && sortBy!.isNotEmpty) data['sort_by'] = sortBy;
    if (sortOrder != null && sortOrder!.isNotEmpty) {
      data['sort_order'] = sortOrder;
    }

    return data;
  }

  // Copy with
  AdvancedSearchFilter copyWith({
    String? query,
    int? categoryId,
    int? subCategoryId,
    String? city,
    double? minPrice,
    double? maxPrice,
    String? type,
    String? featureType,
    String? sortBy,
    String? sortOrder,
    int? page,
    int? perPage,
  }) {
    return AdvancedSearchFilter(
      query: query ?? this.query,
      categoryId: categoryId ?? this.categoryId,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      city: city ?? this.city,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      type: type ?? this.type,
      featureType: featureType ?? this.featureType,
      sortBy: sortBy ?? this.sortBy,
      sortOrder: sortOrder ?? this.sortOrder,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }

  // Helper: Check if any filter is applied
  bool get hasFilters =>
      categoryId != null ||
      subCategoryId != null ||
      city != null ||
      minPrice != null ||
      maxPrice != null ||
      type != null ||
      featureType != null;

  // Clear all filters except query
  AdvancedSearchFilter clearFilters() {
    return AdvancedSearchFilter(
      query: query,
      sortBy: 'date',
      sortOrder: 'desc',
      page: 1,
      perPage: perPage,
    );
  }
}
