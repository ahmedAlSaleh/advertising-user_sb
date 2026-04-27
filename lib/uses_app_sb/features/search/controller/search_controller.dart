import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../core/server/helper_api.dart';
import '../../../core/server/server_config.dart';
import '../../../core/shared/models/search_model.dart';
import '../../../core/shared/widgets/snacl_bar/snackbar_manager.dart';

class SearchController extends GetxController {
  // Loading states
  RxBool isSearching = false.obs;
  RxBool isLoadingAdvanced = false.obs;

  // Data
  Rx<SearchResultModel?> searchResults = Rx<SearchResultModel?>(null);
  RxString searchQuery = ''.obs;

  // Filter
  Rx<AdvancedSearchFilter> filter = AdvancedSearchFilter().obs;

  // Form controllers
  final TextEditingController searchController = TextEditingController();

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  /// Simple Search
  /// GET /api/user/search?q={query}
  Future<void> simpleSearch(String query, {bool isGuest = false}) async {
    if (query.trim().isEmpty) return;

    try {
      isSearching.value = true;
      searchQuery.value = query;

      final endpoint = isGuest
          ? ServerConstApis.simpleSearchGuest
          : ServerConstApis.simpleSearch;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: '$endpoint?q=$query',
        method: "GET",
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error searching: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            searchResults.value = SearchResultModel.fromJson(apiResponse.data!);

            if (kDebugMode) {
              print("Search results: ${searchResults.value?.totalResults} items");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Exception searching: $e");
      }
      SnackbarManager.showSnackbar(
        'حدث خطأ أثناء البحث',
        backgroundColor: appTheme.error,
      );
    } finally {
      isSearching.value = false;
    }
  }

  /// Advanced Search
  /// POST /api/search/advanced
  Future<void> advancedSearch() async {
    try {
      isLoadingAdvanced.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.advancedSearch,
        method: "POST",
        data: filter.value.toJson(),
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error advanced search: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            searchResults.value = SearchResultModel.fromJson(apiResponse.data!);

            if (kDebugMode) {
              print("Advanced search results: ${searchResults.value?.totalResults} items");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Exception advanced search: $e");
      }
      SnackbarManager.showSnackbar(
        'حدث خطأ أثناء البحث المتقدم',
        backgroundColor: appTheme.error,
      );
    } finally {
      isLoadingAdvanced.value = false;
    }
  }

  /// Update Filter
  void updateFilter(AdvancedSearchFilter newFilter) {
    filter.value = newFilter;
  }

  /// Clear Filter
  void clearFilter() {
    filter.value = filter.value.clearFilters();
  }

  /// Clear Search Results
  void clearResults() {
    searchResults.value = null;
    searchQuery.value = '';
    searchController.clear();
  }

  /// Helper: Check if has results
  bool get hasResults => searchResults.value?.hasResults ?? false;

  /// Helper: Total results count
  int get totalResults => searchResults.value?.totalResults ?? 0;
}
