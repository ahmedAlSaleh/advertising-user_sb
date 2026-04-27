import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../core/server/helper_api.dart';
import '../../../core/server/server_config.dart';
import '../../../core/shared/models/advertisement_model.dart';
import '../../../core/shared/models/user.dart';
import '../../../core/shared/widgets/snacl_bar/snackbar_manager.dart';

class AdvertisementController extends GetxController {
  // Loading states
  RxBool isLoadingAds = true.obs;
  RxBool isLoadingFeatured = false.obs;
  RxBool isLoadingMore = false.obs;

  // View states
  RxBool isGridView = true.obs;

  // Data
  RxList<AdvertisementModel> advertisements = <AdvertisementModel>[].obs;
  RxList<AdvertisementModel> featuredAds = <AdvertisementModel>[].obs;

  // Pagination
  Rx<PaginatedAdsResponse?> paginationData = Rx<PaginatedAdsResponse?>(null);
  RxInt currentPage = 1.obs;

  // Filter
  Rx<AdvertisementFilter> filter = AdvertisementFilter().obs;

  // Scroll controller for pagination
  late ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    scrollController.addListener(_onScroll);
    loadInitialData();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// Handle scroll for pagination
  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      loadMore();
    }
  }

  /// Load initial data
  Future<void> loadInitialData() async {
    await Future.wait([
      getAdvertisements(),
      getFeaturedAdvertisements(),
    ]);
  }

  /// Get Advertisements (User or Guest)
  /// POST /api/user/get_ads or /api/user/guest/get_ads
  Future<void> getAdvertisements({
    AdvertisementFilter? customFilter,
    bool isGuest = false,
  }) async {
    try {
      isLoadingAds.value = true;

      final filterToUse = customFilter ?? filter.value;

      // Choose endpoint based on authentication
      final endpoint = isGuest
          ? ServerConstApis.getAdvertizeGuest
          : ServerConstApis.getAdvertize;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: endpoint,
        method: "POST",
        token: isGuest ? null : token,
        data: filterToUse.toJson(),
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error fetching advertisements: ${apiException.message}");
          }
          SnackbarManager.showSnackbar(
            apiException.message,
            backgroundColor: appTheme.error,
          );
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            paginationData.value = PaginatedAdsResponse.fromJson(apiResponse.data!);
            advertisements.value = paginationData.value!.data;
            currentPage.value = paginationData.value!.currentPage;

            if (kDebugMode) {
              print("Advertisements loaded: ${advertisements.length} items");
              print(paginationData.value);
            }
          } else {
            SnackbarManager.showSnackbar(
              apiResponse.message ?? "Failed to load advertisements",
              backgroundColor: appTheme.error,
            );
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error loading advertisements: $e");
      }
      SnackbarManager.showSnackbar(
        "حدث خطأ في تحميل الإعلانات",
        backgroundColor: appTheme.error,
      );
    } finally {
      isLoadingAds.value = false;
    }
  }

  /// Load more advertisements (pagination)
  Future<void> loadMore() async {
    if (isLoadingMore.value || paginationData.value == null) return;
    if (!paginationData.value!.hasMore) return;

    try {
      isLoadingMore.value = true;

      final nextPage = currentPage.value + 1;
      final filterWithNextPage = filter.value.copyWith(page: nextPage);

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.getAdvertize,
        method: "POST",
        token: token,
        data: filterWithNextPage.toJson(),
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error loading more: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            final newData = PaginatedAdsResponse.fromJson(apiResponse.data!);
            advertisements.addAll(newData.data);
            paginationData.value = newData;
            currentPage.value = newData.currentPage;

            if (kDebugMode) {
              print("Loaded more: ${newData.data.length} items");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error loading more: $e");
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  /// Get Featured Advertisements
  /// GET /api/ads/featured
  Future<void> getFeaturedAdvertisements() async {
    try {
      isLoadingFeatured.value = true;

      final response = await ApiHelper.makeRequest<Map<String, dynamic>>(
        targetRout: ServerConstApis.getFeaturedAds,
        method: "GET",
      );

      response.fold(
        (apiException) {
          if (kDebugMode) {
            print("Error fetching featured ads: ${apiException.message}");
          }
        },
        (apiResponse) {
          if (apiResponse.isSuccess && apiResponse.data != null) {
            final dynamic responseData = apiResponse.data;
            final List<dynamic> dataList = responseData is List
                ? responseData
                : (responseData is Map ? (responseData['data'] ?? []) : []);

            featuredAds.value = List<AdvertisementModel>.from(
              dataList.map((x) => AdvertisementModel.fromJson(x)),
            );

            if (kDebugMode) {
              print("Featured ads loaded: ${featuredAds.length} items");
            }
          }
        },
      );
    } catch (e) {
      if (kDebugMode) {
        print("Error loading featured ads: $e");
      }
    } finally {
      isLoadingFeatured.value = false;
    }
  }

  /// Apply filter
  Future<void> applyFilter(AdvertisementFilter newFilter) async {
    filter.value = newFilter;
    currentPage.value = 1;
    await getAdvertisements(customFilter: newFilter);
  }

  /// Reset filter
  Future<void> resetFilter() async {
    filter.value = AdvertisementFilter();
    currentPage.value = 1;
    await getAdvertisements();
  }

  /// Refresh all data
  Future<void> refreshData() async {
    currentPage.value = 1;
    await loadInitialData();
  }

  /// Format price for display
  String formatPrice(double price) {
    return price.toStringAsFixed(0);
  }

  /// Get total pages
  int getTotalPages() {
    return paginationData.value?.totalPages ?? 0;
  }

  /// Check if has more
  bool get hasMore {
    return paginationData.value?.hasMore ?? false;
  }

  /// Check if loading
  bool get isLoading {
    return isLoadingAds.value;
  }

  /// Check if has active filter
  bool get hasActiveFilter {
    return filter.value.categoryId != null ||
        filter.value.subCategoryId != null ||
        filter.value.city != null ||
        filter.value.minPrice != null ||
        filter.value.maxPrice != null ||
        filter.value.type != null;
  }

  /// Toggle view between grid and list
  void toggleView() {
    isGridView.value = !isGridView.value;
  }

  /// Clear specific filter
  Future<void> clearFilter(String filterType) async {
    switch (filterType) {
      case 'category':
        filter.value = AdvertisementFilter(
          city: filter.value.city,
          minPrice: filter.value.minPrice,
          maxPrice: filter.value.maxPrice,
          type: filter.value.type,
          page: 1,
          perPage: filter.value.perPage,
        );
        break;
      case 'city':
        filter.value = AdvertisementFilter(
          categoryId: filter.value.categoryId,
          subCategoryId: filter.value.subCategoryId,
          minPrice: filter.value.minPrice,
          maxPrice: filter.value.maxPrice,
          type: filter.value.type,
          page: 1,
          perPage: filter.value.perPage,
        );
        break;
      case 'price':
        filter.value = AdvertisementFilter(
          categoryId: filter.value.categoryId,
          subCategoryId: filter.value.subCategoryId,
          city: filter.value.city,
          type: filter.value.type,
          page: 1,
          perPage: filter.value.perPage,
        );
        break;
      case 'type':
        filter.value = AdvertisementFilter(
          categoryId: filter.value.categoryId,
          subCategoryId: filter.value.subCategoryId,
          city: filter.value.city,
          minPrice: filter.value.minPrice,
          maxPrice: filter.value.maxPrice,
          page: 1,
          perPage: filter.value.perPage,
        );
        break;
    }
    currentPage.value = 1;
    await getAdvertisements();
  }
}
