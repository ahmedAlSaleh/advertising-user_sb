/// Sub-Category Model
class SubCategoryModel {
  final int id;
  final String name;
  final int categoryId;

  SubCategoryModel({
    required this.id,
    required this.name,
    required this.categoryId,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      categoryId: json['category_id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category_id': categoryId,
    };
  }
}

/// Category Model
class CategoryModel {
  final int id;
  final String name;
  final List<SubCategoryModel> subCategories;

  CategoryModel({
    required this.id,
    required this.name,
    this.subCategories = const [],
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      subCategories: json['sub_categories'] != null
          ? List<SubCategoryModel>.from(
              json['sub_categories'].map((x) => SubCategoryModel.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sub_categories': subCategories.map((x) => x.toJson()).toList(),
    };
  }

  // Helper: Check if has sub-categories
  bool get hasSubCategories => subCategories.isNotEmpty;

  // Helper: Get sub-category by ID
  SubCategoryModel? getSubCategoryById(int id) {
    try {
      return subCategories.firstWhere((sub) => sub.id == id);
    } catch (e) {
      return null;
    }
  }
}
