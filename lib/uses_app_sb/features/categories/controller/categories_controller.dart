import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../core/server/helper_api.dart';
import '../../../core/server/server_config.dart';
import '../../../core/shared/models/category_model.dart';

class CategoriesController extends GetxController {
  // Loading states
  RxBool isLoadingCategories = false.obs;
  RxBool isLoadingCities = false.obs;

  // Data
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxList<String> cities = <String>[].obs;

  /// Get All Categories
  /// GET /api/categories (no auth)
  Future<void> getCategories() async {
    try {
      isLoadingCategories.value = true;

      final response = await ApiHelper.makeRequest<List<dynamic>>(
        targetRout: ServerConstApis.getStoresCategories,
        method: "GET",
        // No token - public endpoint
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error loading categories: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            categories.value = List<CategoryModel>.from(
              apiResponse.data!.map((x) => CategoryModel.fromJson(x)),
            );

            if (kDebugMode) {
              print("Categories loaded: ${categories.length}");
              print("Total sub-categories: ${_getTotalSubCategories()}");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Exception loading categories: $e");
      }
    } finally {
      isLoadingCategories.value = false;
    }
  }

  /// Get All Cities
  /// GET /api/cities (no auth)
  Future<void> getCities() async {
    try {
      isLoadingCities.value = true;

      final response = await ApiHelper.makeRequest<List<dynamic>>(
        targetRout: ServerConstApis.getCities,
        method: "GET",
        // No token - public endpoint
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error loading cities: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            cities.value = List<String>.from(apiResponse.data!);

            if (kDebugMode) {
              print("Cities loaded: ${cities.length}");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Exception loading cities: $e");
      }
    } finally {
      isLoadingCities.value = false;
    }
  }

  /// Load all data
  Future<void> loadAll() async {
    await Future.wait([
      getCategories(),
      getCities(),
    ]);
  }

  /// Helper: Get category by ID
  CategoryModel? getCategoryById(int id) {
    try {
      return categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Helper: Get sub-category by ID (search in all categories)
  SubCategoryModel? getSubCategoryById(int id) {
    for (var category in categories) {
      final subCat = category.getSubCategoryById(id);
      if (subCat != null) return subCat;
    }
    return null;
  }

  /// Helper: Get all sub-categories (flattened)
  List<SubCategoryModel> getAllSubCategories() {
    List<SubCategoryModel> allSubs = [];
    for (var category in categories) {
      allSubs.addAll(category.subCategories);
    }
    return allSubs;
  }

  /// Helper: Get total number of sub-categories
  int _getTotalSubCategories() {
    return categories.fold(0, (sum, cat) => sum + cat.subCategories.length);
  }

  /// Helper: Check if has categories
  bool get hasCategories => categories.isNotEmpty;

  /// Helper: Check if has cities
  bool get hasCities => cities.isNotEmpty;
}
